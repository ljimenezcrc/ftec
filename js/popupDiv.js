/* -----------------------------------------------
popupDiv.js
para usarlo Copiar y pegar:
<style>
	#layer1 {
	position: absolute;
	visibility: hidden;
	width: 400px;
	height: 300px;
	left: 20px;
	top: 300px;
	background-color: #ccc;
	border: 1px solid #000;
	padding: 10px;
}
#close {
	float: right;
}
</style>
<script type="text/javascript" src="../../js/popupDiv.js"></script>
<div id="layer1">
  <p>Aqui va toda la ayuda que quieran poner..</p>
  <br><br>
    <span id="close"><a href="javascript:setVisible('layer1')" style="text-decoration: none"><strong>Ocultar</strong></a></span>
</div>
<a href="#" onclick="setVisible('layer1');return false" target="_self">Abrir popup</a>
 ------------------------------------------------ */
x = 20;
y = 70;
function setVisible(obj)
{
	obj = document.getElementById(obj);
	obj.style.visibility = (obj.style.visibility == 'visible') ? 'hidden' : 'visible';
}
function placeIt(obj)
{
	obj = document.getElementById(obj);
	if (document.documentElement)
	{
		theLeft = document.documentElement.scrollLeft;
		theTop = document.documentElement.scrollTop;
	}
	else if (document.body)
	{
		theLeft = document.body.scrollLeft;
		theTop = document.body.scrollTop;
	}
	theLeft += x;
	theTop += y;
	obj.style.left = theLeft + 'px' ;
	obj.style.top = theTop + 'px' ;
	setTimeout("placeIt("+obj+")",500);
}
//window.onscroll = setTimeout("placeIt('layer1')",500);
