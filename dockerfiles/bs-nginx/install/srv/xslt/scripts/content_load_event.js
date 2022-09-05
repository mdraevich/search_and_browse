document.addEventListener('DOMContentLoaded', function(){ 
    function calculateSize(size)
    {
    var sufixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var output = size;
    var q = 0;
    while (size / 1024 > 1)
    {
        size = size / 1024;
        q++;
    }
    return (Math.round(size * 100) / 100) + ' ' + sufixes[q];
    }

    if (window.location.pathname == '/')
    {
        document.querySelector('.directory.go-up').style.visibility = 'hidden';
    }
            var path = decodeURI(window.location.pathname).split('/');
            var nav = document.querySelector("nav#breadcrumbs ul");
            var pathSoFar = '';

            for (var i=2; i<path.length-1; i++)
            {
                pathSoFar += '/' + path[i];
                if (i < path.length-2) {
                    nav.innerHTML += '<li><a href="/index' + encodeURI(pathSoFar)  + '/">' + path[i] + '</a></li>';
                } else {
                    nav.innerHTML += '<li><a>' + path[i] + '</a></li>';
                }
            }

    var mtimes = document.querySelectorAll("table#contents td.mtime a");
    for (var i=0; i<mtimes.length; i++)
    {
        var mtime = mtimes[i].textContent;
        if (mtime)
        {
            var d = new Date(mtime);
            mtimes[i].textContent = d.toLocaleString();
        }
    }
    var sizes = document.querySelectorAll("table#contents td.size a");
    for (var i=0; i<sizes.length; i++)
    {
        var size = sizes[i].textContent;
        if (size)
        {
            sizes[i].textContent = calculateSize(parseInt(size));
        }
    }

}, false);