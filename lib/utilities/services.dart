// import 'dart:io';

// import 'package:http/http.dart';
// import 'package:http/http.dart' as http;
// import 'package:wordpower_official_app/models/channel_info.dart';
// import 'package:wordpower_official_app/models/video_model.dart';
// import 'package:wordpower_official_app/utilities/keys.dart';

// class Services {
//   static const CHANNEL_ID = 'UCR_Rn21bNrAqK0fHgatW9Ww';
//   static const _baseUrl = 'youtube.googleapis.com';

// // 'https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=UCR_Rn21bNrAqK0fHgatW9Ww&access_token=AIzaSyD1USBh5d16YOn-lbgirn6f_Rm5IobYiCc&key=[YOUR_API_KEY]' \
// //   --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
// //   --header 'Accept: application/json' \
// //   --compressed

//   static Future<ChannelInfo> getChannelInfo() async {
//     Map<String, String> parameters = {
//       'part': 'snippet,contentDetails,statistics',
//       'id': CHANNEL_ID,
//       'key': Constants.API_KEY,
//     };
//     Map<String, String> headers = {
//       HttpHeaders.contentTypeHeader: 'application/json',
//     };
//     Uri uri = Uri.https(
//       _baseUrl,
//       '/youtube/v3/channels',
//       parameters,
//     );
//     Response response = await http.get(uri, headers: headers);
//     // print(response.body);
//     ChannelInfo channelInfo = channelInfoFromJson(response.body);
//     return channelInfo;
//   }

//   static Future<VideosList> getVideosList(
//       {required String playListId, required String pageToken}) async {
//     Map<String, String> parameters = {
//       'part': 'snippet',
//       'playlistid': playListId,
//       'maxResults': '8',
//       'pageToken': pageToken,
//       'key': Constants.API_KEY,
//     };

//     Map<String, String> headers = {
//       HttpHeaders.contentTypeHeader: 'application/json',
//     };
//     Uri uri = Uri.https(
//       _baseUrl,
//       '/youtube/v3/playlistItems',
//       parameters,
//     );
//     Response response = await http.get(uri, headers: headers);
//     // print(response.body);
//     VideosList videosList = videosListFromJson(response.body);
//     return videosList;
//   }
// }
