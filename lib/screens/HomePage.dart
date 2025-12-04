import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:uuid/uuid.dart';
import '../utils/colors.dart';
import 'db_helper.dart';
import 'api_service.dart';

// Define the colors as requested


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Chat Users
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'User');
  final ChatUser _botUser = ChatUser(id: '2', firstName: 'AI Bot');

  // State Variables
  List<ChatMessage> _messages = [];
  List<Map<String, dynamic>> _sessions = [];
  String _currentSessionId = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSessions();
    _startNewSession();
  }

  // --- Session Management ---

  void _startNewSession() {
    setState(() {
      _currentSessionId = const Uuid().v4();
      _messages = [];
    });
    // CHANGED: We do NOT save to DB here anymore.
    // The session will be saved in _handleSendMessage when the first message is sent.
  }

  Future<void> _loadSessions() async {
    final sessions = await DatabaseHelper.instance.getSessions();
    setState(() {
      _sessions = sessions;
    });
  }

  // --- NEW: Delete Session ---
  Future<void> _deleteSession(String sessionId) async {
    await DatabaseHelper.instance.deleteSession(sessionId);
    await _loadSessions(); // Refresh list

    // If we deleted the active session, start a new one to avoid errors
    if (sessionId == _currentSessionId) {
      _startNewSession();
    }
  }

  Future<void> _loadSessionMessages(String sessionId, String title) async {
    setState(() {
      _currentSessionId = sessionId;
      _isLoading = true;
    });

    final dbMessages = await DatabaseHelper.instance.getMessages(sessionId);

    List<ChatMessage> loadedMessages = dbMessages.map((m) {
      final isUser = m['role'] == 'user';
      return ChatMessage(
        text: m['content'],
        user: isUser ? _currentUser : _botUser,
        createdAt: DateTime.parse(m['created_at']),
      );
    }).toList();

    setState(() {
      _messages = loadedMessages.reversed.toList();
      _isLoading = false;
    });

    Navigator.pop(context); // Close the drawer
  }

  // --- Sending Messages ---

  Future<void> _handleSendMessage(ChatMessage chatMessage) async {
    setState(() {
      _messages.insert(0, chatMessage);
      _isLoading = true;
    });

    // 1. Save User Message
    await DatabaseHelper.instance.insertMessage(
      _currentSessionId,
      'user',
      chatMessage.text,
    );

    // 2. Create/Update Session (Only runs on the first message of a session)
    if (_messages.length == 1) {
      String newTitle = chatMessage.text.length > 20
          ? '${chatMessage.text.substring(0, 20)}...'
          : chatMessage.text;

      // This will now CREATE the session entry in the DB since we didn't do it in startNewSession
      await DatabaseHelper.instance.insertSession(_currentSessionId, newTitle);

      // Refresh the drawer to show the new chat in history
      _loadSessions();
    }

    // 3. Prepare History for API
    final dbHistory = await DatabaseHelper.instance.getMessages(_currentSessionId);

    List<Map<String, String>> apiHistory = [];
    for (var row in dbHistory) {
      if (row['content'] == chatMessage.text && row['role'] == 'user') continue;

      apiHistory.add({
        "role": row['role'],
        "content": row['content']
      });
    }

    // 4. Call API
    String responseText = await ApiService.sendChatRequest(
      _currentSessionId,
      chatMessage.text,
      apiHistory,
    );

    // 5. Save Bot Response
    await DatabaseHelper.instance.insertMessage(
      _currentSessionId,
      'assistant',
      responseText,
    );

    // 6. Update UI
    ChatMessage botMessage = ChatMessage(
      user: _botUser,
      createdAt: DateTime.now(),
      text: responseText,
    );

    setState(() {
      _messages.insert(0, botMessage);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- CUSTOM APP BAR ---
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))
        ),
        title: const Text(
          "Med Chat AI",
          style: TextStyle(color: AppColors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),

      // --- DRAWER ---
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.appColor,
              ),
              accountName: const Text("History", style: TextStyle(fontSize: 20)),
              accountEmail: Text("Total Chats: ${_sessions.length}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.white,
                child: Icon(Icons.history, color: AppColors.appColor),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add, color: AppColors.appColor),
              title: const Text("Start New Chat", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                _startNewSession();
              },
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _sessions.length,
                itemBuilder: (context, index) {
                  final session = _sessions[index];
                  final isSelected = session['id'] == _currentSessionId;
                  return Container(
                    color: isSelected ? AppColors.appColor.withOpacity(0.1) : null,
                    child: ListTile(
                      leading: Icon(
                          Icons.chat_bubble_outline,
                          color: isSelected ? AppColors.appColor : Colors.grey
                      ),
                      title: Text(
                        session['title'] ?? 'Untitled Chat',
                        style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.appColor : Colors.black87
                        ),
                      ),
                      subtitle: Text(
                        session['created_at'].toString().split('T')[0],
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () => _loadSessionMessages(session['id'], session['title']),
                      // ADDED: Delete Button
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          // Show confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Delete Chat"),
                              content: const Text("Are you sure you want to delete this chat history?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    _deleteSession(session['id']);
                                  },
                                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // --- CHAT BODY ---
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              currentUser: _currentUser,
              onSend: _handleSendMessage,
              messages: _messages,
              typingUsers: _isLoading ? [_botUser] : [],

              // --- MESSAGE STYLING ---
              messageOptions: MessageOptions(
                showOtherUsersAvatar: true,
               // showUserAvatar: false,

                // User Bubble Style (Right)
                currentUserContainerColor: AppColors.appColor,
                currentUserTextColor: AppColors.white,

                // Bot Bubble Style (Left)
                containerColor: Colors.grey.shade200,
                textColor: Colors.black87,

                // Timestamp styling
                timeFontSize: 10,
                currentUserTimeTextColor: Colors.grey.shade600,
              ),

              // --- INPUT STYLING ---
              inputOptions: InputOptions(
                alwaysShowSend: true,
                inputDisabled: _isLoading,
                sendButtonBuilder: (onSend) {
                  return IconButton(
                    icon: const Icon(Icons.send),
                    color: AppColors.appColor,
                    onPressed: onSend,
                  );
                },
                inputDecoration: InputDecoration(
                  hintText: "Ask about medicine...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.appColor, width: 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}