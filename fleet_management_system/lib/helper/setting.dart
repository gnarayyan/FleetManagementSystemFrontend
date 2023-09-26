const port = 74;

const mobileUrl = 'http://192.168.1.$port:8000/';
const webUrl = 'http://localhost:8000/';

const baseUrl = mobileUrl; //mobileUrl; //// Update it before 'flutter run'

const apiUrl = '${baseUrl}api/';
const testUrl = '${apiUrl}account/register/test/';
const accountUrl = '${apiUrl}account/';
const refreshToken = '${accountUrl}token/refresh/';
//-----
const scheduleUrl =
    'http://192.168.1.$port:8000/api/schedule/?collection_route=';

int userCollectionRoute = 0;
