<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Heatmaps</title>
    <style>
        html, body, #map-canvas {
            height: 100%;
            margin: 0px;
            padding: 0px
        }
        #panel {
            position: absolute;
            top: 5px;
            left: 50%;
            margin-left: -180px;
            z-index: 5;
            background-color: #fff;
            padding: 5px;
            border: 1px solid #999;
        }
    </style>



    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&signed_in=true&libraries=visualization"></script>
    <script>
        // Adding 500 Data Points
        //var map, pointarray, heatmap;

        //var pointArray;

        var pointArray;
        var heatmap;

        $(document).ready(function(){
            $("#show_map").click(function(){
                $.get("api/tweet", function(data, status){
                    pointArray = new google.maps.MVCArray([]);
                    for(var i=0 ; i<data.length; i++){
                        pointArray.push(new google.maps.LatLng(data[i].latitude, data[i].longitude));
                    }
                    heatmap.setData(pointArray);
                });
            });
        });

        $(document).ready(function(){
            $("#select_hash").click(function(){
                if($("#HashTags").val() !== ""){
                    $("#select_hash").attr('disabled',true);
                    var path = "api/tweet/getHashTag/"+ $("#HashTags").val();
                    $.get(path, function(data, status){
                        pointArray = new google.maps.MVCArray([]);
                        for(var i=0 ; i<data.length; i++){
                            pointArray.push(new google.maps.LatLng(data[i].latitude, data[i].longitude));
                        }
                        heatmap.setData(pointArray);
                    });
                    $("#select_hash").attr('disabled',false);
                } else{
                    pointArray = new google.maps.MVCArray([]);
                    heatmap.setData(pointArray);
                }
            });
        });


        function initialize() {
            var mapOptions = {
                zoom: 13,
                center: new google.maps.LatLng(37.774546, -122.433523),
                mapTypeId: google.maps.MapTypeId.SATELLITE
            };

            map = new google.maps.Map(document.getElementById('map-canvas'),
                    mapOptions);

            pointArray = new google.maps.MVCArray([]);

            heatmap = new google.maps.visualization.HeatmapLayer({
                data: pointArray
            });

            heatmap.setMap(map);
            heatmap.set('radius' ,20);
        }

        function toggleHeatmap() {
            heatmap.setMap(heatmap.getMap() ? null : map);
        }

        function changeGradient() {
            var gradient = [
                'rgba(0, 255, 255, 0)',
                'rgba(0, 255, 255, 1)',
                'rgba(0, 191, 255, 1)',
                'rgba(0, 127, 255, 1)',
                'rgba(0, 63, 255, 1)',
                'rgba(0, 0, 255, 1)',
                'rgba(0, 0, 223, 1)',
                'rgba(0, 0, 191, 1)',
                'rgba(0, 0, 159, 1)',
                'rgba(0, 0, 127, 1)',
                'rgba(63, 0, 91, 1)',
                'rgba(127, 0, 63, 1)',
                'rgba(191, 0, 31, 1)',
                'rgba(255, 0, 0, 1)'
            ]
            heatmap.set('gradient', heatmap.get('gradient') ? null : gradient);
        }

        function changeRadius() {
            heatmap.set('radius', heatmap.get('radius') ? null : 20);
        }

        function changeOpacity() {
            heatmap.set('opacity', heatmap.get('opacity') ? null : 0.2);
        }

        google.maps.event.addDomListener(window, 'load', initialize);

    </script>
</head>

<body>
<div id="panel">
    <select id="HashTags">
        <option value=""></option>
        <option value="home">#home</option>
        <option value="work">#work</option>
        <option value="game">#game</option>
        <option value="movie">#movie</option>
        <option value="play">#play</option>
    </select>
    <button id="select_hash">Search HashTag</button>

</div>
<div id="map-canvas"></div>
</body>
</html>