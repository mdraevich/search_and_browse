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
            // console.log(data);

            for (let i = 0; i < data.length; i++) {
                // prepare
                var raw_url = data[i]["url"];
                var url;
                var directory = data[i]["_formatted"]["hierarchy_lvl0"];
                var filename = data[i]["_formatted"]["hierarchy_lvl1"];

                var subcategory = ""
                var SUBCATEGORY_LIMIT = 55;

                // reformat
                {
                    url = new URL(raw_url).pathname;
                    url = decodeURI(url);
                    url = url.replaceAll("</em>", "<=em>");
                    url = url.slice(0, url.lastIndexOf('/'));
                    url = url.replaceAll("/", '\xa0\xa0\xa0→\xa0<i class="fa fa-folder"></i> ');
                    url = url.replaceAll("<=em>", "</em>");
                }
                {
                    if (filename == null && directory == null) {
                        filename = decodeURI(new URL(raw_url).pathname).slice(0, url.lastIndexOf('/'));
                        filename = filename.split('/').slice(-1)[0];
                    }
                    if (filename) {
                        // match file name
                        subcategory = filename;

                        if(subcategory.replaceAll("<em>", "").replaceAll("</em>", "").length > SUBCATEGORY_LIMIT) {
                            subcategory = subcategory.substring(0,SUBCATEGORY_LIMIT) + "...";
                        }
                        subcategory = '<i class="fa fa-file"></i> ' + subcategory;

                    } else {                        
                        // match directory name
                        subcategory = directory;

                        if(subcategory.replaceAll("<em>", "").replaceAll("</em>", "").length > SUBCATEGORY_LIMIT) {
                            subcategory = subcategory.substring(0,SUBCATEGORY_LIMIT) + "...";
                        }
                        subcategory = '<i class="fa fa-folder-yellow"></i> ' + subcategory;

                    } 



                }


                // apply
                data[i]["_formatted"]["hierarchy_lvl0"] = '<i class="fa fa-home"></i>' + url;
                data[i]["hierarchy_lvl0"] = "main"
                
                data[i]["_formatted"]["hierarchy_lvl1"] = subcategory;
                data[i]["hierarchy_lvl1"] = "main";

                data[i]["_formatted"]["hierarchy_lvl2"] = ' ';
                data[i]["hierarchy_lvl2"] = ' ';

                data[i]["url"] = new URL(data[i]["url"]).pathname + new URL(data[i]["url"]).hash
                // data[i]["_formatted"]["hierarchy_lvl3"] = ' ';
                // data[i]["_formatted"]["hierarchy_lvl4"] = ' ';
                // data[i]["_formatted"]["hierarchy_lvl5"] = ' ';
                // data[i]["_formatted"]["hierarchy_lvl6"] = ' ';
                // data[i]["_formatted"]["content"] = ' ';

            }
            // console.log(data);
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




