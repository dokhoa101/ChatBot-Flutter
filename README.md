# 🤖 Flutter Chatbot App

Ứng dụng chatbot xây dựng bằng Flutter, sử dụng **Gemini API** (Google AI) để trò chuyện thông minh bằng **văn bản và hình ảnh**. Dữ liệu được lưu trữ cục bộ bằng **Hive**, hỗ trợ hoạt động cả khi offline.

## 🔑 Tính năng

- Chat văn bản + gửi ảnh đến Gemini
- Lưu lịch sử trò chuyện với Hive
- Giao diện tối/sáng
- Hoạt động offline (đọc lịch sử)

## 🚀 Cài đặt

```bash
git clone https://github.com/dokhoa101/ChatBot-Flutter
cd AIChatbot
flutter pub get
```

Tạo file `.env` và thêm:

```
API_KEY=your_api_key
```

Chạy app:

```bash
flutter run
```

## 🧱 Tech Stack

- Flutter
- Gemini API (Google AI)
- Hive
- image_picker

## 📄 License

MIT License