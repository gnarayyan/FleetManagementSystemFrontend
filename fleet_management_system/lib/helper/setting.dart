const port = 105;

const mobileUrl = 'http://192.168.0.$port:8000/';
const webUrl = 'http://localhost:8000/';

const baseUrl = mobileUrl; //mobileUrl; //// Update it before 'flutter run'

const apiUrl = '${baseUrl}api/';
const testUrl = '${apiUrl}account/register/test/';
const accountUrl = '${apiUrl}account/';
const refreshToken = '${accountUrl}token/refresh/';

const wasteUrl = '${apiUrl}waste/demand/wastes/';
//-----
const scheduleUrl = 'http://192.168.0.$port:8000/api/schedule/';

int userCollectionRoute = 0;

// ---
var wasteForChoices = {'On Demand Waste': 0, 'Waste for Money': 1};
var wasteNatureChoices = {'Organic': 1, 'Plastic': 2, 'Glass': 3, 'Debris': 4};
