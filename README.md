![Header](https://raw.githubusercontent.com/jokilic/razgovorko/main/screenshots/header-wide.png)

# Razgovorko 💬

💬 **Razgovorko** is a simple chat application made in **Flutter**. 👨‍💻

Some text here...

### Razgovorko can be downloaded from [HERE](https://play.google.com/store/apps/details?id=com.josipkilic.razgovorko).
&nbsp;

![Multi](https://raw.githubusercontent.com/jokilic/razgovorko/main/screenshots/multi.png)

### General To-Dos

- [ ] Lots of things
- [ ] Introduce indexes on the tables for better performance
- [ ] Introduce some security on the tables
- [ ] Replace all Exceptions with returning
- [ ] Remove all success logs

## Database structure

### User

- [ ] id - Required - Unique value taken from auth when registering
- [ ] email - Required - Taken when registering, possible to change in `UserSettings`
- [ ] phoneNumber - Required - Taken when registering, possible to change in `UserSettings`
- [ ] displayName - Required - Taken when registering, possible to change in `UserSettings`
- [ ] avatarUrl - non-Required - Taken when registering, possible to change in `UserSettings`
- [ ] status - non-Required - Taken when registering, possible to change in `UserSettings`
- [ ] aboutMe - non-Required - Taken when registering, possible to change in `UserSettings`
- [ ] location - non-Required - Taken when registering, possible to change in `UserSettings`
- [ ] dateOfBirth - non-Required - Taken when registering, possible to change in `UserSettings`
- [ ] isOnline - Required - Updated when app starts, gets terminated or paused
- [ ] lastSeen - Required - Updated when app gets terminated or paused
- [ ] createdAt - Required - Taken when registering, non possible to change
- [ ] updatedAt - Required - Updated when changing any of `UserSettings`
- [ ] deletedAt - non-Required - Taken when user deletes account
- [ ] pushNotificationToken - non-Required - Need to read about notification and handle this properly

### Chat

- [ ] id - Unique value taken when creating chat
- [ ] chatType - Required - Can be individual or group, taken when creating chat
- [ ] name - Required - Taken when creating group-chat, can be updated in `ChatSettings`
- [ ] description - non-Required - Taken when creating group-chat, can be updated in `ChatSettings`
- [ ] avatarUrl - non-Required - Taken when creating group-chat, can be updated in `ChatSettings`
- [ ] lastMessageId - non-Required - Updated when a message is sent in relevant chat
- [ ] createdAt - Required - Taken when chat is created
- [ ] createdBy - Required - Taken when chat is created
- [ ] updatedAt - non-Required - Updated when changing any of `ChatSettings`
- [ ] deletedAt - non-Required - Updated when deleting chat
- [ ] participants - Required - Updated when creating chat or group chat adds / removes participants

### ChatUserStatus

* Each user participating in a specific chat has this value

- [ ] id - Unique value taken when creating chat
- [ ] userId - Required - id of user participating in the chat
- [ ] chatId - Required - id of chat
- [ ] lastReadMessageId - non-Required - id of last read message in the chat by a specific user
- [ ] lastReadAt - non-Required - When the last message was read in the chat by a specific user
- [ ] isMuted - Required - true if user muted this specific chat
- [ ] isPinned - Required - true if user pinned this specific chat
- [ ] isTyping - Required - true if user is typing a message in this specific chat
- [ ] role - Required - can be owner, admin or member. Taken when creating group-chat, can be updated in `ChatSettings`
- [ ] joinedAt - Required - taken when creating chat or when user joins a group-chat
- [ ] leftAt - non-Required - taken when user leaves a group-chat

### Message

- [ ] id - Unique value taken when creating message
- [ ] chatId - Required - id of chat where message is sent
- [ ] senderId - Required - id of sender who sent a message
- [ ] messageType - Required - can be text, image, video, etc., taken when sending a message
- [ ] content - Required - Can be text, URL to media, etc., taken when sending or editing a message
- [ ] replyToMessageId - non-Required - id of user which is replied to
- [ ] isViewOnce - Required - true if message is view-once
- [ ] isDeleted - Required - true if message is deleted
- [ ] createdAt - Required - Taken when message is sent
- [ ] updatedAt - non-Required - Taken when message is updated
- [ ] deletedAt - non-Required - Taken when message is deleted

### MessageUserStatus

- [ ] id - Unique value taken when creating message
- [ ] userId - Required - id of user
- [ ] messageId - Required - id of message
- [ ] reaction - non-Required - reaction to a message by a specific user
- [ ] createdAt - Taken for each user when message gets created
- [ ] viewedAt - Taken when user views a message
