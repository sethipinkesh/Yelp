# Yelp
**Yelp** is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: 14 hours spent in total

## User stories

The following **required** functionality is completed:
- [X] Search results page
   - [X] Table rows should be dynamic height according to the content height.
   - [X] Custom cells should have the proper Auto Layout constraints.
   - [X] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [X] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [X] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
   - [X] The filters table should be organized into sections as in the mock.
   - [X] You can use the default UISwitch for on/off states.
   - [X] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [X] Display some of the available Yelp categories (choose any 3-4 that you want).

The following **optional** features are implemented:

- [X] Search results page
   - [X] Infinite scroll for restaurant results.
   - [X] Implement map view of restaurant results.
- [X] Filter page
   - [X] Implement a custom switch instead of the default UISwitch.
   - [X] Distance filter should expand as in the real Yelp app
   - [X] Categories should show a subset of the full list with a "See All" row to expand. Category list is [here](http://www.yelp.com/developers/documentation/category_list).
- [X] Implement the restaurant detail page.

The following **additional** features are implemented:

- [X] Details page contians map for the selected business
- [X] Progress bar while fetching business

**discuss further with your peers** 
1. Tables sections
2. View hierarchy
3. Annimation and UI

## Video Walkthrough

Here's a walkthrough of implemented user stories:


GIF created with [LiceCap](http://www.cockos.com/licecap/).
 
## Notes
- Autolayout when mutiple labels are horrizontaly placed
- Table with mutiple section and custom switches
- Handling Yelp API based on the selected data

# Credits: 
- AFNetworking
- BDBOAuth1Manager
- SevenSwitch
- MBProgressHUD

For icons: https://iconmonstr.com
