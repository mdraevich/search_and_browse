var meilisearch_access_file = new URL('/search/access.json', window.location)
var meilisearch_search = new URL('/search', window.location)


$.getJSON(meilisearch_access_file.href, function(data) {
    docsSearchBar({
        hostUrl: meilisearch_search.href,
        apiKey: data.meilisearch_search_api_key,
        indexUid: data.meilisearch_index_name,
        inputSelector: '#search-bar-input',
        enhancedSearchInput: true,
        enableDarkMode: true,
        meilisearchOptions: {
            limit: 10,
        },
        debug: false,
        transformData: function (data) {

            for (let i = 0; i < data.length; i++) {
                var OBJECT_NAME_LIMIT = 75;

                // prepare
                var url_raw = new URL(data[i]["url"]);
                var url = new URL(data[i]["_formatted"]["url"]);

                var object_name = data[i]["_formatted"]["hierarchy_lvl1"];
                var object_name_raw = data[i]["hierarchy_lvl1"];


                // reformat
                var filesystem_path, filesystem_path_array;

                filesystem_path_array = decodeURI(url.pathname);
                filesystem_path_array = filesystem_path_array.replaceAll("</em>", "<=em>");
                filesystem_path_array = filesystem_path_array.split("/").filter(item => item);
                filesystem_path_array[0] = '<i class="fa fa-home"></i>'

                filesystem_path = filesystem_path_array.join('\xa0\xa0\xa0→\xa0<i class="fa fa-folder"></i> ') 
                filesystem_path = filesystem_path.replaceAll("<=em>", "</em>");


                // trim object name if it's too long
                if (object_name_raw.length > OBJECT_NAME_LIMIT) {
                    object_name = object_name.substring(0, OBJECT_NAME_LIMIT) + "...";
                }
                
                // #file or #directory prefix should exists
                if (url_raw.hash.startsWith("#file")) {
                    object_name = '<i class="fa fa-file"></i> ' + object_name;
                }
                else {
                    object_name = '<i class="fa fa-folder-yellow"></i> ' + object_name;
                }

                // set formatted value to display
                data[i]["_formatted"]["hierarchy_lvl0"] = filesystem_path;
                data[i]["_formatted"]["hierarchy_lvl1"] = object_name;
                data[i]["_formatted"]["hierarchy_lvl2"] = ' ';
                
                // remove hostname from url - must use relative links behind reverse proxy
                data[i]["url"] = url_raw.pathname + url_raw.hash

            }
            return data;
        },
    });

    // set anchor highlighting
    var last_anchor;        
    function highlight_anchor_element () {
        try {
            document.getElementById(decodeURI(last_anchor)).style.color = null;
            document.getElementById(decodeURI(last_anchor)).fontWeight = "normal";
        } catch {} 
        try {
            last_anchor = window.location.hash.substr(1);
            document.getElementById(decodeURI(last_anchor)).style.color = "aqua";
            document.getElementById(decodeURI(last_anchor)).fontWeight = "bolder";
        } catch {}
    }
    window.onhashchange = highlight_anchor_element;
    highlight_anchor_element();





    // set searchbox hint
    document.getElementById('docs-searchbar-suggestion').placeholder='Ctrl + /';

    // let escape button to focus out from searchbox
    document.onkeydown = function(evt) {
        evt = evt || window.event;
        if (evt.keyCode == 27) {  // 27 is the code for escape
            document.getElementById("docs-searchbar-suggestion").blur(); 
        }
    };



}).fail(function(jqxhr, textStatus, error) {
    var err = textStatus + ", " + error;
    console.log("Request Failed: " + err);
});




