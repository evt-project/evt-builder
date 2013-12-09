/**
 * 
 * @author JK
 * @since 2012
 *
 **/
 
var magnifierON = false;
var bigImage;

function magnifierReady(){
    $("#mag_image_elem").empty();
    var img=document.getElementById("iviewerImage").cloneNode(false);
    img.removeAttribute("style");
    /*IT: calcolo nuova altezza: */
    zoomImagWidth = 445;
    var imgWidth = parseFloat($("#iviewerImage").css('width'));
    var imgHheight = parseFloat($("#iviewerImage").css('height'));
    var newHeight = (zoomImagWidth * imgHheight)/imgWidth;
    //var left_headerHeight = $("#left_header").height();
    /*IT: modifico gli attibuti della nuova immagine*/
    img.setAttribute( 'id' , 'magImage'  );
    /*IT: inserisco nuova immagine in #mag_image_elem */ 
    imgB= "data/input_data/images/"+location.hash.replace( /^#/, '' )+"_big.jpg";
    $("#mag_image_elem").append('<a href="'+imgB+'" class="magnifier" title="image_'+location.hash.replace( /^#/, " ")+'_big"></a>');
    $("#mag_image_elem > a").append(img);
    //$("#mag_image_elem").css({'margin-top': left_headerHeight+'px', 'height': ($("#image_cont").height())-left_headerHeight+'px'});
    /*IT: imposto il css della nuova immagine*/
    $("#magImage").css({'width': zoomImagWidth+'px', 'height': newHeight+'px', 'margin-left': 'auto', 'margin-right': 'auto'});
    setTimeout(function(){magON(); },1000);
   
}

function magOn(){
    if (magnifierON==false){
        /*IT: Se il collegamento testo immagine è attivo, lo disattivo*/
        if (ITLon == true){
            UnInitialize();//Add by JK for ITL
		    //document.getElementById("switchITL").setAttribute('src','images/ITLoff.png');//Add by JK for ITL
            $('#switchITL').removeClass('inactive'); //Add by CDP for FA
		}
        /*IT: rendo visibile il div del magnifier e invisibile quello dello zoom*/
        $("#mag_image_elem").css({'display':'block'});

        $("#image_elem, #image_tool").css({'display':'none'});
        //$('#image_tool').addClass('menuClosed'); //Add by CDP per gestire la scomparsa del menu
        //document.getElementById("switchZoom").setAttribute('src','images/zoomOff.png');
        //document.getElementById("switchMag").setAttribute('src','images/mag.png');
        $('#switchMag').addClass('active');//Add by CDP for FA
        $('#switchITL').removeClass('inactive');//Add by CDP for FA
        disableITLbutton();
        magnifierON = true;
    } else {
        /*IT: rendo visibile il div dello dello zoom e invisibile quello del magnifier*/
        $("#image_elem").css({"display" : "block",    "overflow": "hidden" });
        if(!$('#image_tool').hasClass('menuClosed')) $("#image_tool").css({"display" : "block",    "overflow": "hidden"}); //Add by CDP per gestire la scomparsa del menu
        $("#mag_image_elem").css({'display':'none'});
        //  document.getElementById("switchZoom").setAttribute('src','images/zoom.png');
        //document.getElementById("switchMag").setAttribute('src','images/magOff.png');
        $('#switchMag').removeClass('active');//Add by CDP for FA
        enableITLbutton();//Add by CDP
        //document.getElementById("switchITL").setAttribute('src','images/ITLoff.png');//Add by JK for ITL
        magnifierON = false;
    }
}

function disableITLbutton(){
    //document.getElementById("switchITL").setAttribute('src','images/ITLdis.png');//Add by JK for ITL
    $('#switchITL').addClass('inactive');//Add by CDP for FA
    $('#switchITL').removeAttr("onclick");
    //$('#switchITL i').removeClass('fa-chain').addClass('fa-chain-broken'); //Add by CDP for FA
}
function enableITLbutton(){
    $('#switchITL').removeClass('inactive');
    $('#switchITL').attr('onclick',  'switchIMT()');
}

function disableHSbutton(){
    //document.getElementById("switchITL").setAttribute('src','images/ITLdis.png');//Add by JK for ITL
    $('#switchHS').addClass('inactive');//Add by CDP for FA
    $('#switchHS').removeAttr("onclick");
    $('#switchHS i').removeClass('fa fa-dot-circle-o').addClass('fa fa-dot-circle-o'); //Add by CDP for FA
}
function enableHSbutton(){
    $('#switchHS').removeClass('inactive');
    $('#switchHS').attr('onclick',  'switchHS()');
}

function zoomOn(){
    if (magnifierON==true){
        /*IT: rendo visibile il div dello dello zoom e invisibile quello del magnifier*/
        $("#image_elem").css({"display" : "block",    "overflow": "hidden" });
        document.getElementById("mag_image_elem").setAttribute('style', 'display:none;');
        document.getElementById("switchZoom").setAttribute('src','images/zoom.png');
        //document.getElementById("switchMag").setAttribute('src','images/magOff.png');
        $('#switchMag').removeClass('active');//Add by CDP for FA
        $("#image_elem, #image_tool").show();
        //document.getElementById("switchITL").setAttribute('src','images/ITLoff.png');//Add by JK for ITL
        $('#switchITL').removeClass('inactive'); //Add by CDP for FA
        magnifierON = false;
    }
}

function chooseZoomMag(){   
    if ((magnifierON==true)&&(bigImage==true)){
        //alert("MAg");
        /*IT: rendo visibile il div del magnifier e invisibile quello dello zoom*/
        $("#image_elem, #image_tool").css('display','none');
        $("#mag_image_elem").css({'display':'block'});
        // document.getElementById("switchZoom").setAttribute('src','images/zoomOff.png');
        //document.getElementById("switchMag").setAttribute('src','images/mag.png');
        $('#switchMag').removeClass('inactive');//Add by CDP for FA
        //document.getElementById("#image_tool").setAttribute('style', 'display:none;');
    }
    else if ((magnifierON==false)||((magnifierON==true)&&(bigImage==false))){
        /*IT: rendo visibile il div dello dello zoom e invisibile quello del magnifier*/
        magnifierON==false;
        $("#mag_image_elem").css({"display":"none"});
        $("#image_elem").css({"display" : "block", "overflow": "hidden" });
        if(!$('#image_tool').hasClass('menuClosed')) $("#image_tool").css({"display" : "block",    "overflow": "hidden"}); //Add by CDP per gestire la scomparsa del menu
        //$("#switchMag").attr('src','images/magOff.png');
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
