const baseUrlProd = "http://116.202.186.81:4001/v1";
const imageDownloadingEndpoint = "";
const baseUrlStage = "";
const sigInEndPoint = "/users/login";
const exploreEndpoint = "/categories";
const signUpEndPoint = "/users/register";
const forgotPasswordEndPoint = "/users/forgotPassword";
const listingsEndPoint = "/listings";
const searchEndPoint = "$listingsEndPoint/search";
const subCategoriesEndPoint = "/subcategories";
String gatFavoritesEndpoint(String userId) =>"/users/$userId/favorites/";
String deleteFavoritesEndpoint(String userId, String listingId) =>"/users/$userId/favorites/$listingId";
String gatFavoritesListingEndpoint(String userId) =>"/users/$userId/favorites/listings";
const userDetailsEndPoint = "/users";
const uploadImageEndPoint = "/imageUpload";
const fetchUserOwnDataEndPoint = "/me";
const onboardingUserTypeEndPoint = "/userType";
const onboardingUserInterestsEndPoint = "/interests";
const onboardingUserDemographicsEndPoint = "/demographics";
const onboardingCompleteEndpoint = "/onboardingComplete";
const onboardingDetailEndPoint = "/onboardingDetail";
const feedbackEndpoint = "/feedbacks";
const municipalPartyDetailEndPoint = "/virtualTownhall/getMunicipalityById";

// WEATHER API
const weatherEndPoint = "https://api.weatherapi.com/v1/forecast.json";
const weatherApiKey="2ead327db48b49f28e6134655242706";

// FILTER API
const getFilterEndPoint = "";

// VIRTUAL TOWN HALL
const virtualTownHallEndPoint = "/virtualTownhall";


const ortDetailEndPoint = "/cities";

// MEIN ORT
const meinOrtEndPoint = "/meinOrt";

const getPlacesInMunicipalitiesPath = "/getPlacesInMunicipalities";

const mobilityPath = "/mobility";

const participatePath = "/participate";

const favouriteCitiesPath = "/favorites";