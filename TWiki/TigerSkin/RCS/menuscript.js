// Determine browser type (Netscape 6 or IE 5.5).


var isIE5 = (navigator.userAgent.indexOf("MSIE 5.5") > 0) ? 1 : 0;
var isIE5 = (navigator.userAgent.indexOf("MSIE 5") > 0) ? 1 : 0;
var isNS6 = (navigator.userAgent.indexOf("Gecko")    > 0) ? 1 : 0;
var isNS4 = ((navigator.appName.indexOf("Netscape")==0)
			&&(navigator.userAgent.indexOf("Mozilla/4")  == 0)) ? 1 : 0;

//if (isNS4==0)
// alert("This skin has been designed for Netscape 4.x.");

// For IE, adjust menu bar styling.

if (isIE5) {
  document.styleSheets[document.styleSheets.length - 1].addRule("#menuBar", "padding-top:3px");
  document.styleSheets[document.styleSheets.length - 1].addRule("#menuBar", "padding-bottom:3px");
}

// Global variable for tracking the currently active button.

var activeButton = null;

if (isIE5)
  document.onmousedown = pageMousedown;
if (isNS6)
  document.addEventListener("mousedown", pageMousedown, true);

function pageMousedown(event) {

  var className;

  // If the object clicked on was not a menu button or item, close any active
  // menu.

  if (isIE5)
    className = window.event.srcElement.className;
  if (isNS6)
    className = (event.target.className ?
      event.target.className : event.target.parentNode.className);

  //Top menu mouseover
  if (className != "menuButton" && className != "menuItem" && className != "menuItemDiff" && activeButton)
    resetButton(activeButton);
    

  //Left menu show hide
  var eSrc = window.event.srcElement;
  window.event.cancelBubble = true;
  if ("clsShowHide" == eSrc.className) return contentsHeading_click(eSrc);
  
  //Original version of this (with frames support)
  //while ("BODY" != eSrc.tagName) {
  //  if ("clsItem" == eSrc.className || "clsItemSelect" == eSrc.className) return contentsItem_click(eSrc);
  //  else if ("clsShowHide" == eSrc.className || "clsHeading" == eSrc.className) return contentsHeading_click(eSrc);
  //  eSrc = eSrc.parentElement;
  //}
}

function buttonClick(button, menuName) {

  // Blur focus from the link to remove that annoying outline.

  if (!isNS4)
   button.blur();

  // Associate the named menu to this button if not already done.

  if (!button.menu)
  {
   if (isNS4)
    button.menu = document.layers[menuName];
   else
    button.menu = document.getElementById(menuName);
  }


  // Reset the currently active button, if any.

  if (activeButton && activeButton != button)
    resetButton(activeButton);

  // Toggle the button's state.

  if (button.isDepressed)
    resetButton(button);
  else
    depressButton(button);

  return false;
}

function buttonMouseover(button, menuName) {

  // If any other button menu is active, deactivate it and activate this one.
  // Note: if this button has no menu, leave the active menu alone.

  if (activeButton) {
    if (activeButton != button) {
      resetButton(activeButton);
      if (menuName)
        buttonClick(button, menuName);
    }
    else {
    }
  }
  else {
    if (menuName)
      buttonClick(button, menuName);
  }
}

function depressButton(button) {

  // Save current style values so they can be restored later.
  // Only needs to be done once.

  if (!button.oldBackgroundColor) {
    button.oldBackgroundColor = button.style.backgroundColor;
    button.oldBorderBottomColor = button.style.borderBottomColor;
    button.oldBorderRightColor = button.style.borderRightColor;
    button.oldBorderTopColor = button.style.borderTopColor;
    button.oldBorderLeftColor = button.style.borderLeftColor;
    button.oldColor = button.style.color;
    button.oldLeft = button.style.left;
    button.oldPosition = button.style.position;
    button.oldTop = button.style.top;
  }

  // Change style value to make the button looks like it's
  // depressed.

  button.style.backgroundColor = "#99CC99";
  button.style.borderBottomColor = "#99CC99";
  button.style.borderRightColor = "#99CC99";
  button.style.borderTopColor = "#99CC99";
  button.style.borderLeftColor = "#99CC99";
  button.style.color = "#E9E9E9";
  button.style.left = "0px";
  button.style.position = "relative";
  button.style.top = "0px";

  // For IE, force first menu item to the width of the parent menu,
  // this causes mouseovers work for all items even when cursor is
  // not over the link text.

  if (isIE5 && !button.menu.firstChild.style.width)
    button.menu.firstChild.style.width =
      button.menu.offsetWidth + "px";

if (isNS4)
{
  button.menu.left = (window.innerWidth-100);
  button.menu.top  = 0;
  button.menu.visibility = "show";
}
else
{


  // Position the associated drop down menu under the button and
  // show it. Note that the position must be adjusted according to
  // browser, styling and positioning.

  //x = getPageOffsetLeft(button);
  x = getPageOffsetLeft(button);
  y = getPageOffsetTop(button) + button.offsetHeight;
  if (isIE5)
    y += 2;
  if (isNS6) {
    x--;
    y--;
  }
  x -= 20;
  y -= 10;
  button.menu.style.left = x + "px";
  button.menu.style.top  = y + "px";
  button.menu.style.visibility = "visible";
}

  // Set button state and let the world know which button is
  // active.

  button.isDepressed = true;
  activeButton = button;
}

function resetButton(button) {

  // Restore the button's style settings.

  button.style.backgroundColor = button.oldBackgroundColor;
  button.style.borderBottomColor = button.oldBorderBottomColor;
  button.style.borderRightColor = button.oldBorderRightColor;
  button.style.borderTopColor = button.oldBorderTopColor;
  button.style.borderLeftColor = button.oldBorderLeftColor;
  button.style.color = button.oldColor;
  button.style.left = button.oldLeft;
  button.style.position = button.oldPosition;
  button.style.top = button.oldTop;

  // Hide the button's menu.

  if (button.menu)
  {
   if (isNS4)
    button.menu.visibility = "hide";
   else
    button.menu.style.visibility = "hidden";

  }


  // Set button state and clear active menu global.

  button.isDepressed = false;
  activeButton = null;
}

function getPageOffsetLeft(el) {

  // Return the true x coordinate of an element relative to the page.

  return el.offsetLeft + (el.offsetParent ? getPageOffsetLeft(el.offsetParent) : 0);
}


function getPageOffsetTop(el) {

  // Return the true y coordinate of an element relative to the page.

  return el.offsetTop + (el.offsetParent ? getPageOffsetTop(el.offsetParent) : 0);
}


// Swap background colour
function bgcolour(obj, Colour) {
	obj.style.backgroundColor=Colour
}

//Pop up window
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

function MM_findObj(n, d) { //v3.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
}
/* Functions that swaps %PUBURLPATH%/skins/tiger. */
function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

//Left menu folders
var eSelected = null;
function contentsHeading_click(eSrc)  {
	if ("clsShowHide" == eSrc.className) eSrc = document.all[eSrc.sourceIndex + 1];
	var iNumElements = document.all.length;
	for (var i=eSrc.sourceIndex+1;i<iNumElements;i++) {
		var eTemp = document.all[i];
		if ("clsHeading" == eTemp.className) return;
		else if ("clsItemsHide" == eTemp.className)  {
			eTemp.className = "clsItemsShow";
			//No image url in .js - not subject to wiki vars
			//eSrc.style.listStyleImage = "url('images/blueminus.gif')";
			return eSrc.blur();
		}
		else if("clsItemsShow" == eTemp.className)  {
			eTemp.className = "clsItemsHide";
			//No image url in .js - not subject to wiki vars
			//eSrc.style.listStyleImage = "url('images/blueplus.gif')";
			return eSrc.blur();
		}
	}
}
function contentsItem_click(eSrc)  {
	if (document.all["styleView"]) eSrc.target = document.all["styleView"].checked ? "_blank" : "TEXT";
	else if ("" == eSrc.target) eSrc.target = "TEXT"
	if(null != eSelected) eSelected.className = "clsItem";
	eSrc.className = "clsItemSelect";
	eSelected = eSrc;
}



