# Call Logs App

This Flutter application retrieves and displays the call logs on an Android device. Unlike other common implementations that directly use packages like `call_log`, this app utilizes **Method Channels** to fetch the call logs, offering more flexibility and control over the process. 

## Features

- Displays recent call logs with details like:
  - Caller's phone number
  - Call type (incoming, outgoing, or missed)
  - Call date and time
  - Call duration
- Uses Method Channels to access native Android functionality (call logs), improving performance and reducing reliance on third-party packages.

## Method Channels

### What are Method Channels?

Method Channels in Flutter allow you to communicate with the platform-specific code (Android/iOS) using a platform-independent interface. This is especially useful for accessing native device functionality, like reading call logs, that may not be available through Flutter plugins.

Flutter provides a `MethodChannel` class that is used for sending messages between Flutter and the platform. When a Flutter app wants to perform a task that requires platform-specific functionality, it sends a message via a method channel. The native code on the platform handles the request and sends back a response to Flutter.

In this app, we use Method Channels to directly access Android's `CallLog.Calls` content provider and fetch details about the recent calls.

### Method Channel Implementation

In the Android native code (within the `MainActivity.java` or `MainActivity.kt` file), we set up a method channel. This channel listens for messages from Flutter and performs operations (like accessing the call logs) based on the received message.

```java
// In MainActivity.java (Android platform)
MethodChannel(channel).setMethodCallHandler((call, result) -> {
    if (call.method.equals("getCallLogs")) {
        List<Map<String, String>> callLogs = getCallLogs();
        result.success(callLogs);
    } else {
        result.notImplemented();
    }
});
```

Flutter communicates with this method channel, sending a call to retrieve the call logs. The native Android code fetches the logs and returns the result to the Flutter app.

## Call Functions Used

The following functions are used to interact with the Android call logs:

### `getCallLogs()`
- This function is responsible for querying the device's call logs using the Android `ContentResolver`.
- It fetches the following details for each call:
  - **Number**: The phone number associated with the call.
  - **Type**: The type of call (e.g., incoming, outgoing, or missed).
  - **Date**: The date and time when the call was made.
  - **Duration**: The duration of the call.
  
This function uses the Android `CallLog.Calls` content provider to retrieve call log information.

```dart
cursor?.use {
  val numberColumn = it.getColumnIndex(CallLog.Calls.NUMBER)
  val typeColumn = it.getColumnIndex(CallLog.Calls.TYPE)
  val dateColumn = it.getColumnIndex(CallLog.Calls.DATE)
  val durationColumn = it.getColumnIndex(CallLog.Calls.DURATION)

  var recordCount = 0
  while (it.moveToNext()) {
    if (recordCount >= 10) {
      break
    }
    val number = it.getString(numberColumn) ?: "Unknown"
    val type = it.getString(typeColumn) ?: "Unknown"
    val date = it.getString(dateColumn) ?: "Unknown"
    val duration = it.getString(durationColumn) ?: "0"

    val callLog = mapOf(
      "number" to number,
      "type" to type,
      "date" to date,
      "duration" to duration
    )

    callLogs.add(callLog)
    recordCount++
  }
}
```

- **Cursor**: A `Cursor` object is used to iterate through the rows of the call log data.
- The `getColumnIndex` method is used to find the appropriate index for the columns (number, type, date, duration).
- The `moveToNext` function moves through the cursor and retrieves the data for each call.

### Why Use Method Channels?

- **Direct Access**: Using Method Channels allows for direct access to the Android call logs, ensuring that the application can retrieve the most accurate and up-to-date data.
- **Flexibility**: Method Channels offer more control over how data is accessed and handled, compared to relying on external packages.
- **Efficiency**: By directly querying the native Android API, we can reduce the overhead of using additional plugins.

## Getting Started

To run this project, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/SahanWeerasiri/call-logs-app.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

The app will display the recent call logs on an Android device.

## Contributing

If you'd like to contribute to this project, feel free to fork the repository, make changes, and submit a pull request.
