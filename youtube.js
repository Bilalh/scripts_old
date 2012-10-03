(function () {
    // based off http://userscripts.org/scripts/reviews/123836
    var VIDEO_TITLE = document.getElementById('eow-title')['title'];
    var VIDEO_ID = window.location.href.match(/v=[A-Za-z0-9-_]{11}/)[0].substring(2);
    var DEBUG = false;

    // Script settings
     var SETTINGS = {
         "QUALITY": {
             "13": "3GP",
             "17": "3GP (HQ)",
             "5": "240p (FLV)",
             "34": "360p (FLV)",
             "35": "480p (FLV)",
             "18": "360p (MP4)",
             "22": "720p HD(MP4)",
             "37": "1080p HD (MP4)",
             "43": "360p (WebM)",
             "44": "480p (WebM)",
             "45": "720p HD(WebM)",
             "46": "1080p HD (WebM)",
             "100": "360p 3D(WebM)",
             "101": "480p 3D(WebM)",
             "102": "720p 3D(WebM)",
             "82": "360p 3D(MP4)",
             "83": "240p 3D(MP4)",
             "84": "720p 3D(MP4)",
             "85": "520p 3D(MP4)"
         }
     };


     // Get an array of all available download links
     links = getDownloadLinks();

     // Unable to rerieve links. Don't bother generating the buttons.
     if (!links) {
         trace("Download links not found. Terminating script.");
         return
     }

     // Create the main interface div box along with the download button
     createDownloadBox();

     // Populate the combox box with available links
     populateList(links);


function createDownloadBox() {
    //based off http://userscripts.org/scripts/source/123836.user.js
    var headline = document.getElementById('watch-actions');

    // Container
    box = document.createElement('div');
    box.setAttribute('id', 'download-box');
    box.setAttribute('style', 'position:relative;display:inline;color:#131313;');
    headline.appendChild(box);

    // Create the download button
    var button = document.createElement('button');
    button.setAttribute('class', ' yt-uix-tooltip-reverse  yt-uix-button yt-uix-button-default');
    button.setAttribute('id', 'download-button');
    button.setAttribute('type', 'button');
    button.setAttribute('role', 'button');
    button.setAttribute('style', 'position:relative;');
    button.innerHTML = '<span id="download-button-text"> Download</span>';
    box.appendChild(button);
	

    // Download container
    var downloadContainer = document.createElement('div');
    downloadContainer.setAttribute('id', 'download-container');
    downloadContainer.setAttribute('class', 'yt-uix-button-menu yt-uix-button-menu menu-panel');
    downloadContainer.setAttribute('style', 'overflow: auto; padding: 5px 0px 0px 4px; position: absolute; display: block; margin: 4px auto; width: 165px;display:none;');
    button.appendChild(downloadContainer);

    // Download list
    var downloadItems = document.createElement('div');
    downloadItems.innerHTML = "<strong>Available download formats</strong>";
    downloadItems.setAttribute('id', 'download-items');
    downloadItems.setAttribute('style', 'overflow:auto;');
    downloadContainer.appendChild(downloadItems);

}

function getDownloadLinks() {
    var PAGE_SOURCE = document.body.innerHTML;
    var downloadLinks = [];

    try {
        var matches = PAGE_SOURCE.match(/m_map": "url=(.*?)", "/g)[0].split('url=');
    } catch (e) {
        return false;
    }

    // Iterate through each valid download link and clean it up
    for (i = 0; i <= matches.length - 1; i++) {
        // Make sure it's a valid download link
        if (matches[i].indexOf('lscache') !== -1) {
            downloadLinks.push(unescape(matches[i]).replace(/(\\u0026quality.+|\\u0026type.+)/, ''));
        }
    }
    return (downloadLinks.legnth != 0 ? downloadLinks : false);
}

function populateList(list) {
    trace('Populating combo box with ' + list.length + ' links.');
    var dContainer = document.getElementById('download-container');
    var dItems = document.getElementById('download-items');

    // iterate through the download link list and append it to the select combo box
    var listLi = document.createElement('ul');

    for (i = 0; i <= list.length - 1; i++) {
        // Attach the video's title to the download link
        var downloadLink = list[i] + "&title=" + VIDEO_TITLE;

        // Get the itag query string which indicates video format and quality
        var format = downloadLink.match(/itag=\d{1,3}/)[0].substr(5);
        var quality = SETTINGS.QUALITY[format];

        if (typeof quality === 'undefined') {
            trace("Ran into unknown quality: " + format + ". Skipping...");
            continue;
        }
        dItems.appendChild(listLi);
        listLi.innerHTML += '<li><a style="border-bottom:1px solid #F2F2F2;"  href="' + downloadLink + '" class="yt-uix-button-menu-item yt-uix-tooltip ">' + quality + '</a></li>';
    }
    dContainer.appendChild(dItems);
}

function trace(m) {
    if (DEBUG) {
        console.log(m);
    }
}

})();