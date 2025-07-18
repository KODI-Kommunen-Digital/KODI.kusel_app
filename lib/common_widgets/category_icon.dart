
//[
//   { "id": 1, "name": "News" },
//   { "id": 3, "name": "Events" },
//   { "id": 4, "name": "Clubs" },
//   { "id": 5, "name": "Regional Products" },
//   { "id": 6, "name": "Offer / Search" },
//   { "id": 7, "name": "New citizen info" },
//   { "id": 9, "name": "Lost and Found" },
//   { "id": 10, "name": "Company portraits" },
//   { "id": 11, "name": "Carpooling / Public transport" },
//   { "id": 12, "name": "Offers" },
//   { "id": 13, "name": "Eat or Drink" },
//   { "id": 41, "name": "Highlights" }
// ]

String getCategoryIconPath(int categoryId) {
  String path = "";

  switch (categoryId) {
    case 1:
      path = 'fav_category_icon';
      break;
    case 2:
      path = 'event_category_icon';
      break;
    case 3:
      path = 'groups';
      break;
    case 4:
      path = 'shopping_category_icon';
      break;
    case 5:
      path = 'glass_icon';
      break;
    case 6:
      path = 'cap_icon';
      break;
    case 7:
      path = 'paw_icon';
      break;
    case 8:
      path = 'facilities_category_icon';
      break;
    case 9:
      path = 'transport_icon';
      break;
    case 10:
      path = 'fav_category_icon';
      break;
    case 11:
      path = 'gastro_category_icon';
      break;
    case 12:
      path = 'tourism_service_image';
    case 13:
      path = 'tourism_service_image';
    case 14:
      path = 'place_holder_icon';
    case 41:
      path = 'placeholder_category_icon';
      break;
    default:
      path = 'placeholder_category_icon'; // Fallback icon
      break;
  }

  return path;
}
