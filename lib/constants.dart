bool isLocal = false;
const String API_HOST_REMOTE = 'https://api.vidly.app';
const String API_HOST_LOCAL = 'http://3.109.10.225:5000';

String get_API_HOST() {
  return (isLocal) ? API_HOST_LOCAL : API_HOST_REMOTE;
}
