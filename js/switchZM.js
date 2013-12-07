/**
 * 
 * @author JK
 * @since 2012
 *
 **/
 
var magnifierON = false;

function magnifierReady(){
    $("#mag_image_elem").empty();
    var img=document.getElementById("iviewerImage").cloneNode(false);
    img.removeAttribute("style");
    /*IT: calcolo nuova altezza: */
    zoomImagWidth = 445;
    var imgWidth = parseFloat($("#iviewerImage").css('width'));
    var imgHheight = parseFloat($("#iviewerImage").css('height'));
    var newHeight = (zoomImagWidth * imgHheight)/imgWidth;
    /*IT: modifico gli attibuti della nuova immagine*/
    img.setAttribute( 'id' , 'magImage'  );
    /*IT: inserisco nuova immagine in #mag_image_elem */ 
    imgB= "data/input_data/images/"+location.hash.replace( /^#/, '' )+"_big.jpg";
    $("#mag_image_elem").append('<a href="'+imgB+'" class="magnifier" title="image_'+location.hash.replace( /^#/, " ")+'_big"></a>');
    $("#mag_image_elem > a").append(img);
    /*IT: imposto il css della nuova immagine*/
    $("#magImage").css({'width': zoomImagWidth+'px', 'height': newHeight+'px', 'margin-left': 'auto', 'margin-right': 'auto'});
    setTimeout(function(){magON(); },1000);
   
}

function magOn(){
    if (magnifierON==false){
        /*IT: Se il collegamento testo immagine è attivo, lo disattivo*/
        if (Initializing == false){
            UnInitialize();//Add by JK for ITL
		    //document.getElementById("switchITL").setAttribute('src','images/ITLoff.png');//Add by JK for ITL
            $('#switchITL').removeClass('inactive'); //Add by CDP for FA
		}
        /*IT: rendo visibile il div del magnifier e invisibile quello dello zoom*/
        $("#mag_image_elem").css({'display':'block'});
        $("#image_elem, #image_tool").css('display','none');
        //document.getElementById("switchZoom").setAttribute('src','images/zoomOff.png');
        //document.getElementById("switchMag").setAttribute('src','images/mag.png');
        $('#switchMag').addClass('active');//Add by CDP for FA
        $('#switchMag span').text('Magnifier ON');//Add by CDP for FA
        //document.getElementById("switchITL").setAttribute('src','images/ITLdis.png');//Add by JK for ITL
        $('#switchITL').addClass('inactive');//Add by CDP for FA
        $('#switchITL i').removeClass('fa-chain').addClass('fa-chain-broken'); //Add by CDP for FA
        $('#switchITL span').text('ITL OFF');//Add by CDP for FA
        magnifierON = true;
    } else {
        /*IT: rendo visibile il div dello dello zoom e invisibile quello del magnifier*/
        $("#image_elem, #image_tool").css({"display" : "block",    "overflow": "hidden" });
        $("#mag_image_elem").css({'display':'none'});
        //  document.getElementById("switchZoom").setAttribute('src','images/zoom.png');
        //document.getElementById("switchMag").setAttribute('src','images/magOff.png');
        $('#switchMag').removeClass('active');//Add by CDP for FA
        $('#switchMag span').text('Magnifier OFF');//Add by CDP for FA
        $('#switchITL').removeClass('inactive');//Add by CDP for FA
        //document.getElementById("switchITL").setAttribute('src','images/ITLoff.png');//Add by JK for ITL
        magnifierON = false;
    }
}

function zoomOn(){
    if (magnifierON==true){
        /*IT: rendo visibile il div dello dello zoom e invisibile quello del magnifier*/
        $("#image_elem").css({"display" : "block",    "overflow": "hidden" });
        document.getElementById("mag_image_elem").setAttribute('style', 'display:none;');
        document.getElementById("switchZoom").setAttribute('src','images/zoom.png');
        //document.getElementById("switchMag").setAttribute('src','images/magOff.png');
        $('#switchMag').removeClass('active');//Add by CDP for FA
        //document.getElementById("switchITL").setAttribute('src','images/ITLoff.png');//Add by JK for ITL
        $('#switchITL').removeClass('inactive'); //Add by CDP for FA
        magnifierON = false;
    }
}

function chooseZoomMag(){   
    if (magnifierON==true){
        /*IT: rendo visibile il div del magnifier e invisibile quello dello zoom*/
        $("#image_elem, #image_tool").css('display','none');
        $("#mag_image_elem").css({'display':'block'});
        // document.getElementById("switchZoom").setAttribute('src','images/zoomOff.png');
        //document.getElementById("switchMag").setAttribute('src','images/mag.png');
        $('#switchMag').addClass('active');//Add by CDP for FA
        //document.getElementById("#image_tool").setAttribute('style', 'display:none;');
    }
    else if (magnifierON==false){
        /*IT: rendo visibile il div dello dello zoom e invisibile quello del magnifier*/
        document.getElementById("mag_image_elem").setAttribute('style', 'display:none;');
        $("#image_elem").css({"display" : "block",    "overflow": "hidden" });
    }
}

function magON(){
    var options = {  
            zoomType: 'drag',
			position: 'inside',
			title: false,
            lens: true,  
            preloadImages: true,  
            alwaysOn: false,  
			lensWidth: 30,  
            lensHeight: 15,
			zoomRatio: 1
    };  
    $('.magnifier').jqzoom(options);
}
