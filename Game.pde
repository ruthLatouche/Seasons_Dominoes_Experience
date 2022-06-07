//Proyecto Diseño 7 Visual
//Ruth Latouche Jiménez 2019027049

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import tramontana.library.*;
import websockets.*;
import ddf.minim.*;

PBox2D myWorld;
Tramontana t;
Minim minim;
AudioPlayer musicaJuego;
AudioPlayer musicaFin;

//tamaño escenarios y ViewPort
int widthStage, heightStage, qtyHor, qtyVer;
String currentStage;
PVector centerView;
String state;

//Portada
PImage portada;
GifInteracciones tapToContinue;

//Transicion
boolean transicion;
PVector latestPosition;
PVector camara;

//escenarios
int escenario;
long instanteEscFin;
int esperaEscFin;

//Boundaries
int grosor;
color paredFall, paredWinter, paredSpring, paredSummer;
ArrayList<Boundary> boundaries;
ArrayList<Surface> curvas;

//Sonidos
int audio;
AudioSample domino1, domino2, domino3, domino4;
AudioSample hielo1, hielo2, hielo3, hielo4;

//Elementos Fijos 
ArrayList<Fijo> copos;

//Dominos
color colDom;
ArrayList<Domino> dominosFall;
ArrayList<Domino> dominosWinter;
ArrayList<Domino> dominosSpring;
ArrayList<Domino> dominosSummer;
ArrayList<Domino> domSummerWhite;
ArrayList<Domino> domSummerAqua;
ArrayList<Domino> domSummerPink;
ArrayList<Domino> domSummerPurple;
ArrayList<Domino> domSummerBlue;
ArrayList<Domino> hielos;

//Puente
Bridge puente;

//PRUEBA PARTICULAS y Windmill --------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>...
ArrayList<Particle> particulas;
ArrayList<Particle> hojas;

//Bolas
color tipoInteractivo1;
Ball bolaInt1;
GifInteracciones shake1;

color tipoInteractivo2;
Ball bolaInt2;
boolean salto;

ArrayList<Ball> bolas;


//Segunda Interacción Domino
float domIntX, domIntY;
color paredInt;
float deslizar;
Boundary domInt1;
boolean fuerzaDomInt1;
GifInteracciones dragup1;
float r;

float domInt2X, domInt2Y;
Boundary domInt2;
GifInteracciones tap1, shake2;

//Cuarta interaccion 
GifInteracciones dragLeft1;

//Imágenes Smathphone Interacciones
String dragUp, dragLeft, tap, shake, tapShake, noImage, imageFin;

//Molinos
ArrayList<Molino> molinosSpring;

//final
long actualizacion;
int tiempo;
float corY;
float alpha;
GifInteracciones finalGif;
int contador;

PShape back;


void setup() {
  size (1080,768);
  smooth();
  
  myWorld = new PBox2D(this);
  myWorld.createWorld();
  myWorld.setGravity(0,-9.8*2);
  myWorld.listenForCollisions();
  
  t = new Tramontana(this,"000.000.00.00"); //<-------------------------------------------------------------------------------- Here you change to your smartphone tramontana ip
  t.subscribeAttitude(5);
  t.subscribeTouch();
  t.subscribeTouchDrag();
  
  back = loadShape("Fondo.svg");

  
  //Sonido
  minim = new Minim(this);
  musicaJuego = minim.loadFile("musicaJuego.mp3");
  musicaJuego.setVolume(0.3);
  musicaFin = minim.loadFile("musicaFin.mp3");
  musicaFin.setVolume(0.3);
  
  domino1 = minim.loadSample("domino1.mp3");
  domino2 = minim.loadSample("domino2.mp3");
  domino3 = minim.loadSample("domino3.mp3");
  domino4 = minim.loadSample("domino4.mp3");
  
  hielo1 = minim.loadSample("hielo1.mp3");
  hielo2 = minim.loadSample("hielo2.mp3");
  hielo3 = minim.loadSample("hielo3.mp3");
  hielo4 = minim.loadSample("hielo4.mp3");
  
  //Portada
  portada = loadImage("Portada.png");
  tapToContinue = new GifInteracciones(new PVector(539, 660), "tapToContinue");
  
  //Imágenes Interacciones Smartphone
  dragUp = ("https://i.ibb.co/sKdHJ5V/Drag-Up-Cellphone.png");
  dragLeft = ("https://i.ibb.co/9ZFz8t1/Drag-Left-Cellphone.png");
  tap = ("https://i.ibb.co/bdQYm0K/Tap-Cellphone.png");
  shake = ("https://i.ibb.co/xLf7nws/Shake-Cellphone.png");
  tapShake = ("https://i.ibb.co/mBn64sH/Tap-Shake-Cellphone.png");
  noImage = ("https://i.ibb.co/tsJ6Gr9/Nothing.png");
  imageFin = ("https://i.ibb.co/9wXy3rZ/Fin-Cellphone.png");
  
  
  //final
  tiempo = 3000;
  corY = -115;
  alpha = 0;
  finalGif = new GifInteracciones(new PVector(2700, 384), "finalgif");
  contador = 0;
  
  qtyHor = 3;
  qtyVer = 3;
  widthStage = width*qtyHor;
  heightStage = height*qtyVer;
  
  centerView = new PVector(0,0);
  transicion = false;
  
  escenario = 1;
  esperaEscFin = 3000;
  
  //Paredes
  grosor = 10;
  
  paredFall = #FEBB89;
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(895, 383, grosor, 766, 0,paredFall ));
  boundaries.add(new Boundary(1075, 88, grosor, 176, 0,paredFall ));
  boundaries.add(new Boundary(1051, 171, 58, grosor, 0, paredFall));
  boundaries.add(new Boundary(1027, 458, grosor, 564, 0, paredFall));
  boundaries.add(new Boundary(828, 877, 140, grosor, 0, paredFall));
  boundaries.add(new Boundary(755, 895, 10, 45, 0, paredFall));
  boundaries.add(new Boundary(673, 912, 154, grosor, 0, paredFall));
  boundaries.add(new Boundary(404, 1006, 433.96, grosor, radians(26), paredFall));
  boundaries.add(new Boundary(378, 1253, 375, grosor, 0, paredFall));
  boundaries.add(new Boundary(602, 1291, 50, grosor, 0, paredFall));
  boundaries.add(new Boundary(654, 1343, 50, grosor, 0, paredFall));
  boundaries.add(new Boundary(705, 1393, 50, grosor, 0, paredFall));
  boundaries.add(new Boundary(755, 1444, 50, grosor, 0, paredFall));
  boundaries.add(new Boundary(858, 1486, 179.07, grosor, radians(-30), paredFall));
  boundaries.add(new Boundary(1075, 1420, grosor, 233, 0, paredFall));
  
  //Pared Interactiva
  paredInt = #FF8F84;
  domIntX = 561;
  domIntY = 1167;
  domInt1 = new Boundary(domIntX, domIntY, grosor, 163, 0, paredInt);
  dragup1 = new GifInteracciones(new PVector(639, 990), "dragup");
  
  //Pared Interactiva2
  domInt2X = 2756;
  domInt2Y = 1010;
  domInt2 = new Boundary(domInt2X, domInt2Y, 190, grosor, 0, paredInt);
  dragLeft1 = new GifInteracciones(new PVector(2569, 923), "dragleft");

  paredWinter = #65F1EB;
  boundaries.add(new Boundary(1075, 1607, grosor, 142, 0, paredWinter));
  boundaries.add(new Boundary(730, 1838, 393, grosor-2, 0, paredWinter));
  boundaries.add(new Boundary(141, 1718, 15, grosor, 0, paredWinter));
  boundaries.add(new Boundary(254, 1541, 510, grosor, 0, paredWinter));
  boundaries.add(new Boundary(5, 1754, grosor, 420, 0, paredWinter));
  boundaries.add(new Boundary(660, 2131, 1171.47, grosor, radians(-9), paredWinter));
  boundaries.add(new Boundary(272, 2049, 40, 40, radians(-9), paredWinter));
  boundaries.add(new Boundary(492, 2083.71, 40, 40, radians(-9), paredWinter));
  boundaries.add(new Boundary(714, 2119, 40, 40, radians(-9), paredWinter));
  boundaries.add(new Boundary(934, 2153.71, 40, 40, radians(-9), paredWinter));
  boundaries.add(new Boundary(1682, 2222, 888, grosor, 0, paredWinter));
  boundaries.add(new Boundary(1085, 1811, grosor, 550, 0, paredWinter));
  
  //escaleritas winter
  boundaries.add(new Boundary(1248, 2127, 42, grosor, 0, paredWinter));
  boundaries.add(new Boundary(1264, 2112, grosor, 20, 0, paredWinter));
  boundaries.add(new Boundary(1232, 2112, grosor, 20, 0, paredWinter));
  boundaries.add(new Boundary(1306, 2077, 50, grosor, 0, paredWinter));
  boundaries.add(new Boundary(1338, 2027, 50, grosor, 0, paredWinter));
  boundaries.add(new Boundary(1370, 1977, 50, grosor, 0, paredWinter));
  boundaries.add(new Boundary(1402, 1927, 50, grosor, 0, paredWinter));
  boundaries.add(new Boundary(1434, 1877, 50, grosor, 0, paredWinter));
  boundaries.add(new Boundary(1466, 1827, 50, grosor, 0, paredWinter));
  boundaries.add(new Boundary(1533, 1777, 129, grosor, 0, paredWinter));
  
  boundaries.add(new Boundary(2093, 1913, 22, grosor, 0, paredWinter));
  boundaries.add(new Boundary(2149, 1913, 22, grosor, 0, paredWinter));
  boundaries.add(new Boundary(2077, 1912, grosor, 21, 0, paredWinter));
  
  paredSpring = #7BE9B9;
  boundaries.add(new Boundary(2165, 1967, grosor, 131, 0, paredSpring));
  boundaries.add(new Boundary(2400, 2117, 290, grosor, 0, paredSpring));
  
  //escaleras spring
  boundaries.add(new Boundary(2572, 2047, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2608, 1977, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2642, 1907, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2678, 1837, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2713, 1767, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2748, 1697, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2782, 1627, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2818, 1557, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2853, 1497, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2888, 1417, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2923, 1347, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2958, 1277, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2993, 1207, 15, grosor, 0, paredSpring));
  
  //Segunda Etapa Spring
  boundaries.add(new Boundary(2864, 1010, 15, grosor, 0, paredSpring));
  boundaries.add(new Boundary(2661, 883, grosor, 229, 0, paredSpring));
  boundaries.add(new Boundary(2457, 1235, 570, grosor, radians(9), paredSpring));
  boundaries.add(new Boundary(1735, 1325, 912, grosor, 0, paredSpring));
  boundaries.add(new Boundary(1666, 1130, 692, grosor, 0, paredSpring));
  
  paredSummer = #FAE36B;
  boundaries.add(new Boundary(1612, 706, 694, grosor, 0, paredSummer));
  boundaries.add(new Boundary(1247, 250, 40, grosor, 0, paredSummer));
  boundaries.add(new Boundary(1729, 465, 867, grosor, 0, paredSummer));
  boundaries.add(new Boundary(2160, 277, 159, grosor, 0, paredSummer));
  boundaries.add(new Boundary(2389, 366, 353.18, grosor, radians(-30), paredSummer));
  boundaries.add(new Boundary(2160, 277, 159, grosor, 0, paredSummer));
  boundaries.add(new Boundary(2328, 321, 33, grosor, 0, paredSummer));
  boundaries.add(new Boundary(2400, 363, 33, grosor, 0, paredSummer));
  boundaries.add(new Boundary(2473, 405, 33, grosor, 0, paredSummer));
  boundaries.add(new Boundary(2588, 754, 693, 29, 0, paredSummer));
  
  boundaries.add(new Boundary(2547, 611, grosor, 255, radians(5), #FFFFFF));
  boundaries.add(new Boundary(2637, 734, 165, grosor, 0, #FFFFFF));
  boundaries.add(new Boundary(2725, 610, grosor, 255, radians(-5), #FFFFFF));
  
  curvas = new ArrayList<Surface>();
  curvas.add(new Surface(890, 740, 137, 0, 90, paredFall));
  curvas.add(new Surface(192, 1137, 116, 90, 255, paredFall));
  curvas.add(new Surface(915, 1678, 160, 0, 90, paredWinter));
  curvas.add(new Surface(82, 1960, 77.09, 90, 182, paredWinter));
  curvas.add(new Surface(2255, 2027, 90, 90, 180, paredSpring));
  curvas.add(new Surface(2673, 1010, 193, 0, 75, paredSpring));

  
  //Elementos Fijos
  
  copos = new ArrayList<Fijo>();
  copos.add(new Fijo(839, 1819, 15, 839, 1541.27, 5, "Winter"));
  copos.add(new Fijo(786, 1814, 15, 786, 1549, 5, "Winter"));
  copos.add(new Fijo(732, 1809, 15, 732, 1559, 5, "Winter"));
  copos.add(new Fijo(682, 1804, 15, 682, 1569, 5, "Winter"));
  copos.add(new Fijo(630, 1799, 15, 630, 1573, 5, "Winter"));
  copos.add(new Fijo(578, 1793, 15, 578, 1587, 5, "Winter"));
  copos.add(new Fijo(526, 1787, 15, 526, 1596.27, 5, "Winter"));
  copos.add(new Fijo(474, 1779, 15, 474, 1606, 5, "Winter"));
  copos.add(new Fijo(422, 1772, 15, 422, 1615, 5, "Winter"));
  copos.add(new Fijo(370, 1763, 15, 370, 1624, 5, "Winter"));
  copos.add(new Fijo(318, 1754, 15, 318, 1633, 5, "Winter"));
  copos.add(new Fijo(267, 1743, 15, 267, 1642, 5, "Winter"));
  copos.add(new Fijo(214, 1728, 15, 214, 1651.27, 5, "Winter"));
  
  /*
  copos.add(new Fijo(1012, 2034, 10, 1012, 1806, 5, "Winter"));
  copos.add(new Fijo(1012, 2054, 10, 1012, 1806, 5, "Winter"));
  copos.add(new Fijo(1012, 2074, 10, 1012, 1806, 5, "Winter"));
  copos.add(new Fijo(1012, 2094, 10, 1012, 1806, 5, "Winter"));
  copos.add(new Fijo(1012, 2114, 10, 1012, 1806, 5, "Winter"));
  copos.add(new Fijo(1012, 2134, 10, 1012, 1806, 5, "Winter"));
  
  copos.add(new Fijo(1085, 1914, 10, 1085, 1683, 5, "Winter"));
  copos.add(new Fijo(1085, 1934, 10, 1085, 1683, 5, "Winter"));
  copos.add(new Fijo(1085, 1954, 10, 1085, 1683, 5, "Winter"));
  copos.add(new Fijo(1085, 1974, 10, 1085, 1683, 5, "Winter"));
  copos.add(new Fijo(1085, 1994, 10, 1085, 1683, 5, "Winter"));
  copos.add(new Fijo(1085, 2014, 10, 1085, 1683, 5, "Winter"));
  */
  
  copos.add(new Fijo(3046, 1050.73, 20, 3046, 768, 5, "Spring"));


  //Dominos |||||||||||||||||||||||||||||||||||||||||||||||||
  dominosFall = new ArrayList<Domino>();
  // Primer Nivel
  dominosFall.add(new Domino(813, 822, 10, 100, "Fall"));
  dominosFall.add(new Domino(760, 822, 10, 100, "Fall"));
  dominosFall.add(new Domino(707, 857, 10, 100, "Fall"));
  dominosFall.add(new Domino(657, 822, 10, 100, "Fall"));
  dominosFall.add(new Domino(606, 822, 10, 100, "Fall"));
 
  
  //Segundo Nivel
  dominosFall.add(new Domino(220, 1198, 10, 100, "Fall"));
  dominosFall.add(new Domino(290, 1198, 10, 100, "Fall"));
  dominosFall.add(new Domino(360, 1198, 10, 100, "Fall"));
  dominosFall.add(new Domino(430, 1198, 10, 100, "Fall"));
  dominosFall.add(new Domino(500, 1198, 10, 100, "Fall"));
  
  //Escaleras
  dominosFall.add(new Domino(603, 1217, 10, 138, "Fall"));
  dominosFall.add(new Domino(654, 1196, 10, 96, "Fall"));
  dominosFall.add(new Domino(654, 1291, 10, 96, "Fall"));
  dominosFall.add(new Domino(705, 1189, 10, 81, "Fall"));
  dominosFall.add(new Domino(705, 1269, 10, 81, "Fall"));
  dominosFall.add(new Domino(705, 1349, 10, 81, "Fall"));
  dominosFall.add(new Domino(755, 1329, 10, 73, "Fall"));
  dominosFall.add(new Domino(755, 1403, 10, 73, "Fall"));
  dominosFall.add(new Domino(755, 1185, 10, 73, "Fall"));
  dominosFall.add(new Domino(755, 1258, 10, 73, "Fall"));
  
  //Invierno
  //Escaleras
  dominosWinter = new ArrayList<Domino>();
  dominosWinter.add(new Domino(1254, 2012, 10, 200, "Winter"));
  dominosWinter.add(new Domino(1286, 1962, 10, 200, "Winter"));
  dominosWinter.add(new Domino(1318, 1912, 10, 200, "Winter"));
  dominosWinter.add(new Domino(1350, 1862, 10, 200, "Winter"));
  dominosWinter.add(new Domino(1382, 1812, 10, 200, "Winter"));
  dominosWinter.add(new Domino(1414, 1762, 10, 200, "Winter"));
  dominosWinter.add(new Domino(1446, 1712, 10, 200, "Winter"));
  
  //Bajo Escaleras
  
  //
  dominosWinter.add(new Domino(1243, 2175, 10, 75, "Winter"));
  dominosWinter.add(new Domino(1281, 2175, 10, 75, "Winter"));
  dominosWinter.add(new Domino(1322, 2175, 10, 75, "Winter"));
  dominosWinter.add(new Domino(1363, 2162, 10, 100, "Winter"));
  dominosWinter.add(new Domino(1423, 2162, 10, 100, "Winter"));
  dominosWinter.add(new Domino(1483, 2162, 10, 100, "Winter"));
  //
  dominosWinter.add(new Domino(1543, 2162, 10, 100, "Winter"));
  dominosWinter.add(new Domino(1603, 2162, 10, 100, "Winter"));
  dominosWinter.add(new Domino(1663, 2162, 10, 100, "Winter"));
  dominosWinter.add(new Domino(1723, 2162, 10, 100, "Winter"));
  dominosWinter.add(new Domino(1783, 2162, 10, 100, "Winter"));
  dominosWinter.add(new Domino(1843, 2162, 10, 100, "Winter"));
  dominosWinter.add(new Domino(1903, 2162, 10, 100, "Winter"));
  //dominosWinter.add(new Domino(1963, 2162, 10, 100, "Winter"));
  //dominosWinter.add(new Domino(2023, 2162, 10, 100, "Winter"));
  //dominosWinter.add(new Domino(2083, 2162, 10, 100, "Winter")); 
  dominosWinter.add(new Domino(1943, 2167, 10, 90, "Winter")); 
  dominosWinter.add(new Domino(1983, 2172, 10, 80, "Winter"));
  dominosWinter.add(new Domino(2023, 2177, 10, 70, "Winter"));
  dominosWinter.add(new Domino(2063, 2182, 10, 60, "Winter"));
  dominosWinter.add(new Domino(2093, 2187, 10, 50, "Winter"));
  
  
  dominosWinter.add(new Domino(2121, 2050, 10, 325, "Winter")); 
  dominosWinter.add(new Domino(2121, 1882, 65, 10, "Winter")); 
  
  //Primavera
  //De pequeño a grande
  dominosSpring = new ArrayList<Domino>();
  dominosSpring.add(new Domino(2337, 2067, 10, 90, "Spring"));
  dominosSpring.add(new Domino(2370, 2062, 10, 100, "Spring"));
  dominosSpring.add(new Domino(2403, 2052, 10, 120, "Spring"));
  dominosSpring.add(new Domino(2436, 2042, 10, 140, "Spring"));
  dominosSpring.add(new Domino(2469, 2032, 10, 160, "Spring"));
  dominosSpring.add(new Domino(2502, 2022, 10, 180, "Spring"));
  dominosSpring.add(new Domino(2535, 2012, 10, 200, "Spring"));
  
  //Escaleritas
  dominosSpring.add(new Domino(2573, 1942, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2608, 1872, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2643, 1802, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2678, 1732, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2713, 1662, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2748, 1592, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2783, 1522, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2818, 1452, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2852, 1382, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2888, 1312, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2923, 1242, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2958, 1172, 10, 200, "Spring"));
  dominosSpring.add(new Domino(2993, 1057, 10, 300, "Spring"));
  
  //Segunda etapa Spring
  dominosSpring.add(new Domino(2146, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(2086, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(2026, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1966, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1906, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1846, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1786, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1726, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1666, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1606, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1546, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1486, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1426, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1366, 1270, 10, 100, "Spring"));
  dominosSpring.add(new Domino(1306, 1270, 10, 100, "Spring"));
  
  dominosSpring.add(new Domino(1325, 1034, 10, 183, "Spring"));
  dominosSpring.add(new Domino(1360, 1034, 10, 183, "Spring"));
  dominosSpring.add(new Domino(1400, 1034, 10, 183, "Spring"));
  dominosSpring.add(new Domino(1445, 1034, 10, 183, "Spring"));
  dominosSpring.add(new Domino(1495, 1034, 10, 183, "Spring"));
  dominosSpring.add(new Domino(1550, 1034, 10, 183, "Spring"));
  dominosSpring.add(new Domino(1613, 1034, 10, 183, "Spring"));
  dominosSpring.add(new Domino(1678, 1034, 10, 183, "Spring"));
  dominosSpring.add(new Domino(1748, 1034, 10, 183, "Spring"));
  dominosSpring.add(new Domino(1823, 1034, 10, 183, "Spring"));
  dominosSpring.add(new Domino(1903, 1034, 10, 183, "Spring"));
  
  dominosSummer = new ArrayList<Domino>();
  dominosSummer.add(new Domino(1953, 651, 12, 100, "Summer"));
  dominosSummer.add(new Domino(1906, 641, 14, 120, "Summer"));
  dominosSummer.add(new Domino(1851, 636, 16, 130, "Summer"));
  dominosSummer.add(new Domino(1789, 631, 18, 140, "Summer"));
  dominosSummer.add(new Domino(1720, 626, 20, 150, "Summer"));
  dominosSummer.add(new Domino(1639, 621, 22, 160, "Summer"));
  dominosSummer.add(new Domino(1561, 616, 24, 170, "Summer"));
  dominosSummer.add(new Domino(1471, 611, 26, 180, "Summer"));
  dominosSummer.add(new Domino(1384, 606, 28, 190, "Summer"));
  dominosSummer.add(new Domino(1280.31, 601, 30, 200, "Summer"));
  
  domSummerWhite = new ArrayList<Domino>(); 
  domSummerWhite.add(new Domino(1380, 338, 10, 243, "Summer"));
  domSummerWhite.add(new Domino(1380, 212, 164, 10, "Summer"));
  domSummerWhite.add(new Domino(1320, 194, 10, 25, "Umbrella"));
  domSummerWhite.add(new Domino(1340, 187, 10, 40, "Umbrella"));
  domSummerWhite.add(new Domino(1360, 182, 10, 50, "Umbrella"));
  domSummerWhite.add(new Domino(1380, 177, 10, 60, "Umbrella"));
  domSummerWhite.add(new Domino(1400, 182, 10, 50, "Umbrella"));
  domSummerWhite.add(new Domino(1420, 187, 10, 40, "Umbrella"));
  domSummerWhite.add(new Domino(1440, 194, 10, 25, "Umbrella"));
  
  domSummerWhite.add(new Domino(1590, 338, 10, 243, "Summer"));
  domSummerWhite.add(new Domino(1590, 212, 164, 10, "Summer"));
  domSummerWhite.add(new Domino(1530, 194, 10, 25, "Umbrella"));
  domSummerWhite.add(new Domino(1550, 187, 10, 40, "Umbrella"));
  domSummerWhite.add(new Domino(1570, 182, 10, 50, "Umbrella"));
  domSummerWhite.add(new Domino(1590, 177, 10, 60, "Umbrella"));
  domSummerWhite.add(new Domino(1610, 182, 10, 50, "Umbrella"));
  domSummerWhite.add(new Domino(1630, 187, 10, 40, "Umbrella"));
  domSummerWhite.add(new Domino(1650, 194, 10, 25, "Umbrella"));
  
  domSummerWhite.add(new Domino(1800, 338, 10, 243, "Summer"));
  domSummerWhite.add(new Domino(1800, 212, 164, 10, "Summer"));
  domSummerWhite.add(new Domino(1740, 194, 10, 25, "Umbrella"));
  domSummerWhite.add(new Domino(1760, 187, 10, 40, "Umbrella"));
  domSummerWhite.add(new Domino(1780, 182, 10, 50, "Umbrella"));
  domSummerWhite.add(new Domino(1800, 177, 10, 60, "Umbrella"));
  domSummerWhite.add(new Domino(1820, 182, 10, 50, "Umbrella"));
  domSummerWhite.add(new Domino(1840, 187, 10, 40, "Umbrella"));
  domSummerWhite.add(new Domino(1860, 194, 10, 25, "Umbrella"));
  
  domSummerWhite.add(new Domino(2010, 338, 10, 243, "Summer"));
  domSummerWhite.add(new Domino(2010, 212, 164, 10, "Summer"));
  domSummerWhite.add(new Domino(1950, 194, 10, 25, "Umbrella"));
  domSummerWhite.add(new Domino(1970, 187, 10, 40, "Umbrella"));
  domSummerWhite.add(new Domino(1990, 182, 10, 50, "Umbrella"));
  domSummerWhite.add(new Domino(2010, 177, 10, 60, "Umbrella"));
  domSummerWhite.add(new Domino(2030, 182, 10, 50, "Umbrella"));
  domSummerWhite.add(new Domino(2050, 187, 10, 40, "Umbrella"));
  domSummerWhite.add(new Domino(2070, 194, 10, 25, "Umbrella"));
  
  domSummerAqua = new ArrayList<Domino>();
  domSummerAqua.add(new Domino(1310, 199, 9, 10, "Umbrella"));
  domSummerAqua.add(new Domino(1330, 190, 9, 33, "Umbrella"));
  domSummerAqua.add(new Domino(1350, 184, 9, 45, "Umbrella"));
  domSummerAqua.add(new Domino(1370, 179, 9, 55, "Umbrella"));
  domSummerAqua.add(new Domino(1390, 179, 9, 55, "Umbrella"));
  domSummerAqua.add(new Domino(1410, 184, 9, 45, "Umbrella"));
  domSummerAqua.add(new Domino(1430, 190, 9, 33, "Umbrella"));
  domSummerAqua.add(new Domino(1450, 199, 9, 10, "Umbrella"));
  
  domSummerPink = new ArrayList<Domino>();
  domSummerPink.add(new Domino(1520, 199, 10, 10, "Umbrella"));
  domSummerPink.add(new Domino(1540, 190, 10, 33, "Umbrella"));
  domSummerPink.add(new Domino(1560, 184, 10, 45, "Umbrella"));
  domSummerPink.add(new Domino(1580, 179, 10, 55, "Umbrella"));
  domSummerPink.add(new Domino(1600, 179, 10, 55, "Umbrella"));
  domSummerPink.add(new Domino(1620, 184, 10, 45, "Umbrella"));
  domSummerPink.add(new Domino(1640, 190, 10, 33, "Umbrella"));
  domSummerPink.add(new Domino(1660, 199, 10, 10, "Umbrella"));
  
  domSummerPurple = new ArrayList<Domino>();
  domSummerPurple.add(new Domino(1730, 199, 10, 10, "Umbrella"));
  domSummerPurple.add(new Domino(1750, 190, 10, 33, "Umbrella"));
  domSummerPurple.add(new Domino(1770, 184, 10, 45, "Umbrella"));
  domSummerPurple.add(new Domino(1790, 179, 10, 55, "Umbrella"));
  domSummerPurple.add(new Domino(1810, 179, 10, 55, "Umbrella"));
  domSummerPurple.add(new Domino(1830, 184, 10, 45, "Umbrella"));
  domSummerPurple.add(new Domino(1850, 190, 10, 33, "Umbrella"));
  domSummerPurple.add(new Domino(1870, 199, 10, 10, "Umbrella"));
  
  domSummerBlue = new ArrayList<Domino>();
  domSummerBlue.add(new Domino(1940, 199, 10, 10, "Umbrella"));
  domSummerBlue.add(new Domino(1960, 190, 10, 33, "Umbrella"));
  domSummerBlue.add(new Domino(1980, 184, 10, 45, "Umbrella"));
  domSummerBlue.add(new Domino(2000, 179, 10, 55, "Umbrella"));
  domSummerBlue.add(new Domino(2020, 179, 10, 55, "Umbrella"));
  domSummerBlue.add(new Domino(2040, 184, 10, 45, "Umbrella"));
  domSummerBlue.add(new Domino(2060, 190, 10, 33, "Umbrella"));
  domSummerBlue.add(new Domino(2080, 199, 10, 10, "Umbrella"));
  
  hielos = new ArrayList<Domino>();
  hielos.add(new Domino(2333, 296, 40, 40, "Hielos"));
  hielos.add(new Domino(2406, 338, 40, 40, "Hielos"));
  hielos.add(new Domino(2479, 380, 40, 40, "Hielos"));

  
  molinosSpring = new ArrayList<Molino>();
  molinosSpring.add(new Molino(1186, 1983, 10, 162 ));
  molinosSpring.add(new Molino(1209, 2109, 10, 162 ));
  molinosSpring.add(new Molino(1269, 1109, 20, 333 ));
  molinosSpring.add(new Molino(2020, 837, 20, 471));
  molinosSpring.add(new Molino(1195, 415, 20, 456 ));
  

  //Particulas
  //HOJAS ()()()()()()()()()()()()()()()()()()()()
  hojas = new ArrayList<Particle>();
  hojas.add(new Particle(861.5, 869.5, "Fall"));
  //
  hojas.add(new Particle(866.5, 869.5, "Fall"));
  hojas.add(new Particle(866.5, 864.5, "Fall"));
  //
  hojas.add(new Particle(871.5, 869.5, "Fall"));
  hojas.add(new Particle(871.5, 864.5, "Fall"));
  hojas.add(new Particle(871.5, 859.5, "Fall"));
  //
  hojas.add(new Particle(876.5, 869.5, "Fall"));
  hojas.add(new Particle(876.5, 864.5, "Fall"));
  hojas.add(new Particle(876.5, 859.5, "Fall"));
  hojas.add(new Particle(876.5, 854.5, "Fall"));
  //
  hojas.add(new Particle(881.5, 869.5, "Fall"));
  hojas.add(new Particle(881.5, 864.5, "Fall"));
  hojas.add(new Particle(881.5, 859.5, "Fall"));
  hojas.add(new Particle(881.5, 854.5, "Fall"));
  hojas.add(new Particle(881.5, 849.5, "Fall"));
  //
  hojas.add(new Particle(881.5, 869.5, "Fall"));
  hojas.add(new Particle(881.5, 864.5, "Fall"));
  hojas.add(new Particle(881.5, 859.5, "Fall"));
  hojas.add(new Particle(881.5, 854.5, "Fall"));
  hojas.add(new Particle(881.5, 849.5, "Fall"));
  hojas.add(new Particle(886.5, 844.5, "Fall"));
  //
  hojas.add(new Particle(891.5, 869.5, "Fall"));
  hojas.add(new Particle(891.5, 864.5, "Fall"));
  hojas.add(new Particle(891.5, 859.5, "Fall"));
  hojas.add(new Particle(891.5, 854.5, "Fall"));
  hojas.add(new Particle(891.5, 849.5, "Fall"));
  //
  hojas.add(new Particle(896.5, 869.5, "Fall"));
  hojas.add(new Particle(896.5, 864.5, "Fall"));
  hojas.add(new Particle(896.5, 859.5, "Fall"));
  hojas.add(new Particle(896.5, 854.5, "Fall"));
  //
  hojas.add(new Particle(901.5, 869.5, "Fall"));
  hojas.add(new Particle(901.5, 864.5, "Fall"));
  hojas.add(new Particle(901.5, 859.5, "Fall"));
  //
  hojas.add(new Particle(906.5, 869.5, "Fall"));
  hojas.add(new Particle(906.5, 864.5, "Fall"));
  //
  hojas.add(new Particle(911.5, 869.5, "Fall"));
  
  //Puente
  puente = new Bridge(1597, 1787, 2072, 1911, 20);
  
  
  //Bolas
  bolaInt1 = new Ball(1031, 136, 30);
  shake1 = new GifInteracciones(new PVector(717, 123), "shake");
  
  bolaInt2 = new Ball(141, 1683, 30);
  tap1 = new GifInteracciones(new PVector(260, 1622), "tap");
  shake2 = new GifInteracciones(new PVector(401, 1622), "shake");
  
  bolas = new ArrayList<Ball>();
  bolas.add(new Ball(1503, 1732, 30)); 
  bolas.add(new Ball(2864, 967, 30)); 
  bolas.add(new Ball(1247, 215, 30));
  bolas.add(new Ball(2110, 242, 30));

    
  //PARTICULAS PRUEBA
  particulas = new ArrayList<Particle>();
  
  
  // Pa que lo vea;
  state = "Portada";
  noStroke();
}

void draw() {
  background(180);
  
  //abre el viewPort 
  //Primer Objeto
  
  if (state == "Fall1") {
    if(bolaInt1.getPos().y < 817){
      viewPort(new PVector(0+r,bolaInt1.getPos().y));
    }
    else{
      state = "Fall1.5";
      latestPosition = new PVector(0,bolaInt1.getPos().y);
      camara = latestPosition;
    }
  }
  
  //Transicion
  if(state == "Fall1.5"){
    if (dominosFall.get(4).getPos().y < 1080){
    viewPortTransition(latestPosition, new PVector(0,dominosFall.get(4).getPos().y), "Fall1.5");
    }
    else{
    viewPortTransition(latestPosition, new PVector(0,dominosFall.get(4).getPos().y), "Fall2");
    }
  }
   
  //Objeto 2
  if (state == "Fall2") {
    if(dist(dominosFall.get(10).getPos().x, dominosFall.get(10).getPos().y, dominosFall.get(11).getPos().x, dominosFall.get(11).getPos().y) > 50){
      viewPort(new PVector(0,dominosFall.get(4).getPos().y));
    }
    else{
      state = "Fall2.5";
      latestPosition = new PVector(0,dominosFall.get(4).getPos().y);
      camara = latestPosition;
    }
  } 
  
  //Transicion
  if(state == "Fall2.5"){
    viewPortTransition(latestPosition, new PVector(0,dominosFall.get(dominosFall.size()-1).getPos().y), "Fall3");
  }
  
  //Objeto 3
  if (state == "Fall3") {
    if(dominosFall.get(dominosFall.size()-1).getPos().y < heightStage-height+20){
      viewPort(new PVector(0,dominosFall.get(dominosFall.size()-1).getPos().y));
    }
    else{
      state = "Winter1";
      latestPosition = new PVector(0,dominosFall.get(dominosFall.size()-1).getPos().y);
      camara = latestPosition;
    }
  }
  
  //Transicion
  if(state == "Winter1"){
    viewPortTransition(latestPosition, new PVector(0, heightStage-height/2), "Winter1.5");
  }
  
  //Objeto 4
  if (state == "Winter1.5") {
    if(bolaInt2.getPos().x < width){
      viewPort(new PVector(bolaInt2.getPos().x, heightStage-height/2));
    }
    else{
      state = "Winter2";
      latestPosition = new PVector(bolaInt2.getPos().x, heightStage-height/2);
      camara = latestPosition;
    }
  }
  
  //Transition
  if(state == "Winter2"){
    if(bolaInt2.getPos().x < 1181){
      viewPortTransition(latestPosition, new PVector(bolaInt2.getPos().x, heightStage-height/2), "Winter2");
    }
    else{
      viewPortTransition(latestPosition, new PVector(bolas.get(0).getPos().x+150, heightStage-height/2), "Winter2.5");
    }
  }
  
  //Objeto5
  if(state == "Winter2.5"){
    if(dominosSpring.get(1).getAngle() > -1 || dominosSpring.get(2).getAngle() > -1 ){
      viewPort(new PVector(bolas.get(0).getPos().x+150, heightStage-height/2));
    }
    else{
      state = "Spring1";
      latestPosition = new PVector(bolas.get(0).getPos().x+150, heightStage-height/2);
      camara = latestPosition;
    }
  }
  
  //Transicion
  if(state == "Spring1"){
      viewPortTransition(latestPosition, new PVector(widthStage, heightStage-height/2), "Spring1.5");
  }
  
  //Objeto 6
  if(state == "Spring1.5"){
    if(dominosSpring.get(11).getAngle() > -1){
    viewPort(new PVector(widthStage, heightStage-height/2));
  }
    else{
      state = "Spring2";
      latestPosition = new PVector(widthStage, heightStage-height/2);
      camara = latestPosition;
    }
  }
  
  //Transition
  if(state == "Spring2"){
      viewPortTransition(latestPosition, new PVector(widthStage, height*2), "Spring2.5");
  }
  
  //Objeto 7
  if(state == "Spring2.5"){
    if(dominosSpring.get(17).getAngle() > -1 ){
      viewPort(new PVector(widthStage, height*2));
  }
    else{
      state = "Spring3";
      latestPosition = new PVector(widthStage, height*2);
      camara = latestPosition;
    }
  }
  
  //Transition
  if(state == "Spring3"){
   viewPortTransition(latestPosition, new PVector(widthStage, height+height/2), "Spring3.5"); 
  }
  
  //Objeto 8
  if(state == "Spring3.5"){
    if(bolas.get(1).getPos().x > 2141){
      viewPort(new PVector(bolas.get(1).getPos().x, height+height/2));
    }
    else{
      state = "Spring4";
      latestPosition = new PVector(bolas.get(1).getPos().x, height+height/2);
      camara = latestPosition;
    }
  }
  
  //Transition
  if(state == "Spring4"){
   viewPortTransition(latestPosition, new PVector(width+width/2, height+height/2), "Spring4.5"); 
  }
  
  
  //Objeto 9
  if(state == "Spring4.5"){
    if(molinosSpring.get(3).getAngle() == 0){
      viewPort(new PVector(width+width/2, height+height/2));
    }
    else{
      state = "Spring5";
      latestPosition = new PVector(width+width/2, height+height/2);
      camara = latestPosition;
    }
  }
  
  //Transicion
   if(state == "Spring5"){
   viewPortTransition(latestPosition, new PVector(width+width/2, molinosSpring.get(3).getPos().y), "Summer1"); 
  }
  
  //Objeto 10
  if(state == "Summer1"){
    if(dominosSummer.get(4).getAngle() == 0){
      viewPort(new PVector(width+width/2, molinosSpring.get(3).getPos().y));
    }
    else{
      state = "Summer1.5";
      latestPosition = new PVector(width+width/2, molinosSpring.get(3).getPos().y);
      camara = latestPosition;
    }
  }
  
  //Transition
  if(state == "Summer1.5"){
   viewPortTransition(latestPosition, new PVector(width+width/2, height/2), "Summer2"); 
  }
  
  //Objeto 11
  if(state == "Summer2"){
    if(degrees(domSummerPurple.get(6).getAngle()) <= 30 && degrees(domSummerPurple.get(6).getAngle()) >= -30){
      viewPort(new PVector(width+width/2, height/2));
    }
    else{
      state = "Summer2.5";
      latestPosition = new PVector(width+width/2, height/2);
      camara = latestPosition;
    }
  }
  
  //Transition
  if(state == "Summer2.5"){
   viewPortTransition(latestPosition, new PVector(bolas.get(3).getPos().x, height/2), "Summer3"); 
  }
  
  //Objeto 12
  if(state == "Summer3"){
    if(bolas.get(3).getPos().x < 2468){
      viewPort(new PVector(bolas.get(3).getPos().x, height/2));
    }
    else{
      state = "Summer3.5";
      latestPosition = new PVector(bolas.get(3).getPos().x, height/2);
      camara = latestPosition;
    }
  }
  
  if(state == "Summer3.5"){
    viewPortTransition(latestPosition, new PVector(widthStage-width/2, height/2), "Summer4");
    actualizacion = millis();
  }
  
  if(state == "Summer4"){
    viewPort(new PVector(widthStage-width/2, height/2));
    if(millis() - actualizacion > tiempo){
      state = "Summer4.5";
    }
  }
  
  //Final
  if(state == "Summer4.5"){
    viewPort(new PVector(widthStage-width/2, height/2));
  }
  
  
  //Imágenes Interacciones smartphone
  if(state == "Portada"){
   t.showImage(tap); 
  }
  if(state == "Fall1"){
    t.showImage(shake);
  }
  else if(state == "Fall2" || state == "Fall2.5"){
    t.showImage(dragUp);
  }
  else if( state == "Winter1.5"){
    t.showImage(tapShake);
  }
  else if(state == "Spring3" || state == "Spring3.5"){
    t.showImage(dragLeft);
  }
  else if(state == "Summer4.5"){
   if( corY >= 294 ){
    t.showImage(imageFin);
   }
  }
  else{
    t.showImage(noImage);
  }
  


  pushMatrix();
  translate(centerView.x, centerView.y); 
  
  if (escenario == 1)
    Portada();
  else if (escenario == 2)
    Juego();

  popMatrix();
}

//Portada ----------------------------------------------------------------------------------------------------------------
void Portada() {
  pushMatrix();
  imageMode(CENTER);
  image(portada, width/2, height/2);
  popMatrix();
  tapToContinue.display();
}

//Juego -------------------------------------------------------------------------------------------------------------------
void Juego(){
  myWorld.step();

  //Background colors
  
  pushMatrix();
  noStroke();
  rectMode(CORNER);
  fill(#FFE3D1);
  rect(0,0, widthStage/3, heightStage*2/3);
  fill(#CDFAE6);
  rect(widthStage/3, heightStage/3, widthStage*2/3, heightStage*2/3);
  fill(#CDFAF8);
  rect(0,heightStage*2/3, widthStage*2/3, heightStage/3);
  fill(#FAF3CD);
  rect(widthStage/3,0, widthStage*2/3, heightStage/3);
  shapeMode(CENTER);
  shape(back, widthStage/2, heightStage/2);
  
  fill(#79F1EC, 70);
  noStroke();
  beginShape();
  vertex(2563, 729);
  vertex(2709, 729);
  vertex(2730, 495);
  vertex(2542, 495);
  endShape(CLOSE);
  
  popMatrix();
  
  
  //Superficies
  for (Boundary wall: boundaries) {
    wall.display();
  }
  for (Surface curva: curvas) {
    curva.display();
  }
  
  if(puente.getPos().x > height && puente.getPos().y > height*2){
    colDom = #7EF1EC;
  }
  puente.display();


  //Elementos  
  
  //Saber color de domino
  //Otono
  for (Domino bloques: dominosFall) {
    if(bloques.posx() > 0 && bloques.posx() < widthStage/3){
       if(bloques.posy() > 0 && bloques.posy() < heightStage*2/3){
         //Fall
         colDom = #F48D81 ;
       }
       else{
         //Winter
         colDom = #C3B6EF ;
       }
      }
      else{
        if(bloques.posy() > 0 && bloques.posy() < heightStage/3){
          //Summer
          colDom = #F2A579 ;
        }
        if(bloques.posy() > heightStage/3 && bloques.posy() < heightStage*2/3){
          //Spring
          colDom = #FBABAC ;
        }
        if(bloques.posy() > heightStage*2/3 && bloques.posy() < heightStage){
          if( bloques.posx() > 0 && bloques.posx() < widthStage*2/3){
            //Winter
            colDom = #C3B6EF ;
          }
          else{
           //Spring
           colDom = #FBABAC ;
          }
    
      }
    }
    bloques.display();
  }
  
  //Invierno
  for (Domino bloques: dominosWinter) {
    if(bloques.posx() > 0 && bloques.posx() < widthStage/3){
       if(bloques.posy() > 0 && bloques.posy() < heightStage*2/3){
         //Fall
         colDom = #F48D81 ;
       }
       else{
         //Winter
         colDom = #C3B6EF ;
       }
      }
      else{
        if(bloques.posy() > 0 && bloques.posy() < heightStage/3){
          //Summer
          colDom = #F2A579 ;
        }
        if(bloques.posy() > heightStage/3 && bloques.posy() < heightStage*2/3){
          //Spring
          colDom = #FBABAC ;
        }
        if(bloques.posy() > heightStage*2/3 && bloques.posy() < heightStage){
          if( bloques.posx() > 0 && bloques.posx() < widthStage*2/3){
            //Winter
            colDom = #C3B6EF ;
          }
          else{
           //Spring
           colDom = #FBABAC ;
          }
    
      }
    }
    bloques.display();
  }
  
  //Primavera
  for (Domino bloques: dominosSpring) {
    if(bloques.posx() > 0 && bloques.posx() < widthStage/3){
       if(bloques.posy() > 0 && bloques.posy() < heightStage*2/3){
         //Fall
         colDom = #F48D81 ;
       }
       else{
         //Winter
         colDom = #C3B6EF ;
       }
      }
      else{
        if(bloques.posy() > 0 && bloques.posy() < heightStage/3){
          //Summer
          colDom = #F2A579 ;
        }
        if(bloques.posy() > heightStage/3 && bloques.posy() < heightStage*2/3){
          //Spring
          colDom = #FBABAC ;
        }
        if(bloques.posy() > heightStage*2/3 && bloques.posy() < heightStage){
          if( bloques.posx() > 0 && bloques.posx() < widthStage*2/3){
            //Winter
            colDom = #C3B6EF ;
          }
          else{
           //Spring
           colDom = #FBABAC ;
          }
    
      }
    }
    bloques.display();
  }
  
  for (Domino bloques: dominosSummer) {
    if(bloques.posx() > 0 && bloques.posx() < widthStage/3){
       if(bloques.posy() > 0 && bloques.posy() < heightStage*2/3){
         //Fall
         colDom = #F48D81 ;
       }
       else{
         //Winter
         colDom = #C3B6EF ;
       }
      }
      else{
        if(bloques.posy() > 0 && bloques.posy() < heightStage/3){
          //Summer
          colDom = #F2A579 ;
        }
        if(bloques.posy() > heightStage/3 && bloques.posy() < heightStage*2/3){
          //Spring
          colDom = #FBABAC ;
        }
        if(bloques.posy() > heightStage*2/3 && bloques.posy() < heightStage){
          if( bloques.posx() > 0 && bloques.posx() < widthStage*2/3){
            //Winter
            colDom = #C3B6EF ;
          }
          else{
           //Spring
           colDom = #FBABAC ;
          }
        }
      }
    bloques.display();
  }
  
  for( Domino d: domSummerWhite){
    colDom = #FFFFFF;
    d.display();
  }
  
  for( Domino d: domSummerAqua){
    colDom = #78F1EC;
    d.display();
  }
  
  for( Domino d: domSummerPink){
    colDom = #FBABAC;
    d.display();
  }
  
  for( Domino d: domSummerPurple){
    colDom = #C5BEF0;
    d.display();
  }
  
  for( Domino d: domSummerBlue){
    colDom = #65CFF1;
    d.display();
  }
  
  for( Domino d: hielos){
    if( d.getPos().y < 530){
      colDom = #FFFFFF;
    }
    else{
      Vec2 fuerza;
      fuerza = new Vec2(0,500);
      d.applyForce(fuerza);
      colDom = #FFFFFF;
    }
    d.display();
  }
  if(bolas.get(3).getPos().y > 530){
    Vec2 fuerza;
    fuerza = new Vec2(0,800);
    bolas.get(3).applyForce(fuerza);
  }
  
  
  //Bolas
  for (Ball b: bolas) {
    if(b.getPos().x > 0 && b.getPos().x < widthStage/3){
       if(b.getPos().y > 0 && b.getPos().y < heightStage*2/3){
         //Fall
         colDom = #FEBB89 ;
       }
       else{
         //Winter
         colDom = #C3B6EF ;
       }
      }
      else{
        if(b.getPos().y > 0 && b.getPos().y < heightStage/3){
          //Summer
          colDom = #F29661 ;
        }
        if(b.getPos().y > heightStage/3 && b.getPos().y < heightStage*2/3){
          //Spring
          colDom = #FBABAC;
        }
        if(b.getPos().y > heightStage*2/3 && b.getPos().y < heightStage){
          if( b.getPos().x > 0 && b.getPos().x < widthStage*2/3){
            //Winter
            colDom = #C3B6EF ;
          }
          else{
           //Spring
           colDom = #FBABAC ;
          }
        }
      }
    b.display();
  }  
  
  //Molinos
  
  for(Molino mol: molinosSpring){
   if(mol.getPos().x > 0 && mol.getPos().x < widthStage/3){
       if(mol.getPos().y > 0 && mol.getPos().y < heightStage*2/3){
         //Fall
         colDom = #FEBB89 ;
       }
       else{
         //Winter
         colDom = #C3B6EF ;
       }
      }
      else{
        if(mol.getPos().y > 0 && mol.getPos().y < heightStage/3){
          //Summer
          colDom = #F29661 ;
        }
        if(mol.getPos().y > heightStage/3 && mol.getPos().y < heightStage*2/3){
          //Spring
          colDom = #FBABAC;
        }
        if(mol.getPos().y > heightStage*2/3 && mol.getPos().y < heightStage){
          if( mol.getPos().x > 0 && mol.getPos().x < widthStage*2/3){
            //Winter
            colDom = #C3B6EF ;
          }
          else{
           //Spring
           colDom = #FBABAC ;
          }
        }
      }
    mol.display();
  }
  
  
    for (Fijo copitos: copos) {
    copitos.display();
  }
  
  //Particulas
  for (Particle hojitas: hojas) {
    hojitas.display();
  }
  
  //PRUEBA PARTICLAS
  
  if(mousePressed){
   particulas.add(new Particle(mouseX-centerView.x, mouseY-centerView.y, "Fall"));
  }
  
  for (Particle p: particulas) {
    p.display();
  }
 
//gif interactivos: indican interacción --------------------
  if(state == "Fall1"){
   shake1.display(); 
  }
  if(state == "Fall2"){
   dragup1.display(); 
  }
  
  if(state == "Spring3.5"){
   dragLeft1.display(); 
  }
  
  if(state == "Winter1.5"){
   tap1.display();
   shake2.display();
  }
 
 
//Elementos Interactivos 
//BOLA------------------------------------------------------------
  if(state == "Fall1"){
    tipoInteractivo1 = #FF3333;
  }
  else{
    tipoInteractivo1 = #FF8F84;
  }
  bolaInt1.displayInt1();  
  
  if(bolaInt2.getPos().x < width && bolaInt2.getPos().y > heightStage-height){
    tipoInteractivo2 = #FF3333;
  }
  else if(bolaInt2.getPos().x < width*2 && bolaInt2.getPos().y > heightStage-height){
    tipoInteractivo2 = #C3B6EF;
  }
  else{
    tipoInteractivo2 = #FBABAC;
  }
  bolaInt2.displayInt2(); 
  if(bolaInt2.getPos().x > 1269){
    Vec2 fuerza = new Vec2(300,0);
    bolaInt2.applyForce(fuerza);
  }
  

  
//Domino Interactivo 1 -------------------------------------------
  if(state == "Fall2"){
    paredInt = #FF3333;
  }
  else{
    paredInt = #FF8F84;
  }
  domInt1.displayInt(domIntX, domIntY, paredInt);
  

  if(fuerzaDomInt1){
    dominosFall.get(9).applyForce(new Vec2(1,0));
  }
  
  if(state == "Spring3.5"){
    paredInt = #FF3333;
  }
  else{
    paredInt = #7BE9B9;
  }
  domInt2.displayInt(domInt2X, domInt2Y, paredInt);
  
  //Llamar final
  if(state == "Summer4.5" ){
   finalizar();
  }
  
}


void playMusicaJuego(){
  musicaJuego.play(); 
  musicaJuego.loop();  
}

void playMusicaFin(){
  musicaJuego.pause();
  musicaFin.play();
  musicaFin.loop();
}

//Final==============================================
void finalizar(){
  if(corY < 294){
   corY +=2;
   alpha += 0.2;
  }
  
  pushMatrix();
  fill(#F29661);
  noStroke();
  circle(3026, corY, 230);
  popMatrix();
  
  pushMatrix();
  fill(#7553FF, alpha);
  noStroke();
  rectMode(CORNER);
  rect(widthStage - width, 0, 1080, 768);
  popMatrix(); 
  

  if( corY >= 294 ){
    finalGif.display();
    if(contador < 1){
      playMusicaFin();
      contador += 1;
    }
  }

}





//View Port ----------------------------------------------------------------------------------------------------------------
void viewPort(PVector mainObject) {
  if (mainObject.x < width/2) {
    centerView.x = 0;
  }
  else if (mainObject.x > widthStage-width/2) {
    centerView.x = -widthStage+width;
  }
  else {
    centerView.x =  map (mainObject.x, width/2, widthStage-(width/2), 0, -1*(widthStage-width));
  }
  
  if (mainObject.y < height/2) {
    centerView.y = 0;
  }
  else if (mainObject.y > heightStage-height/2) {
    centerView.y = -heightStage+height;
  }
  else {
     centerView.y = map (mainObject.y, height/2, heightStage-(height/2), 0, -1*(heightStage-height));
  }
  
  //En cual stage esta
  if(mainObject.x > 0 && mainObject.x < widthStage/3){
   if(mainObject.y > 0 && mainObject.y < heightStage*2/3){
     currentStage = "Fall";
   }
   else{
     currentStage = "Winter";
   }
  }
  else{
    if(mainObject.y > 0 && mainObject.y < heightStage/3){
      currentStage = "Summer";
    }
    if(mainObject.y > heightStage/3 && mainObject.y < heightStage*2/3){
      currentStage = "Spring";
    }
    if(mainObject.y > heightStage*2/3 && mainObject.y < heightStage){
      if( mainObject.x > 0 && mainObject.x < widthStage*2/3){
        currentStage = "Winter";
      }
      else{
       currentStage = "Spring"; 
      }
    
  }
}
}

void viewPortTransition(PVector origen, PVector destino, String nextState) {
  PVector factor = new PVector(destino.x, destino.y);
  factor.sub(origen).div(20);
  camara.add(factor);
  viewPort(camara);
  int cercania = 5;
  if (camara.dist(destino) < cercania) {
    transicion = false;
    state = nextState;
  }
}

// Collision event functions!
void beginContact(Contact cp) {
  // Get both shapes
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
  
  if (o1 == null || o2 == null) {
    return;
  }
    
  
  if (o1.getClass() == Domino.class && o2.getClass() == Domino.class) {
    Domino d1 = (Domino)o1;
    Domino d2 = (Domino)o2;
    
    
    if(state == "Fall1" || state == "Fall1.5" || state == "Fall2" || state == "Fall2.5" || state == "Fall3" ){   
      //Domino Especial
      if(d1 == dominosFall.get(8) && d2 == dominosFall.get(9) || d1 == dominosFall.get(9) && d2 == dominosFall.get(8) ){
        fuerzaDomInt1 = true;
      }
      
      if(d1 == dominosFall.get(10) && d2 == dominosFall.get(9) || d1 == dominosFall.get(9) && d2 == dominosFall.get(10) ){
        fuerzaDomInt1 = false;
      }
      
      //Sonido
      if(d1.getTipo() == "Fall" || d2.getTipo() == "Fall"){
        int audio = int(random(1,5));
        if(audio == 1) domino1.trigger();
        if(audio == 2) domino2.trigger();
        if(audio == 3) domino3.trigger();
        else  domino4.trigger();
      }
    }

    if(state == "Winter1" || state == "Winter1.5" || state == "Winter2" || state == "Winter2.5"){   
      if(d1.getTipo() == "Winter" || d2.getTipo() == "Winter"){
        int audio = int(random(1,5));
        if(audio == 1) domino1.trigger();
        if(audio == 2) domino2.trigger();
        if(audio == 3) domino3.trigger();
        else  domino4.trigger();
      }
    }
    
    if(state == "Spring1" || state == "Spring1.5" || state == "Spring2" || state == "Spring2.5" || state == "Spring3" || state == "Spring3.5" || state == "Spring4" || state == "Spring4.5" || state == "Spring5"){   
      if(d1.getTipo() == "Spring" || d2.getTipo() == "Spring"){
        int audio = int(random(1,5));
        if(audio == 1) domino1.trigger();
        if(audio == 2) domino2.trigger();
        if(audio == 3) domino3.trigger();
        else  domino4.trigger();
      }
    }
    
    if(state == "Summer1" || state == "Summer1.5"){   
      if(d1.getTipo() == "Summer" || d2.getTipo() == "Summer"){
        int audio = int(random(1,5));
        if(audio == 1) domino1.trigger();
        if(audio == 2) domino2.trigger();
        if(audio == 3) domino3.trigger();
        else  domino4.trigger();
      }    
    }
    
    if(state == "Summer2" || state == "Summer2.5" || state == "Summer3"){
      if(d1.getPos().y < 333 || d2.getPos().y < 333){
        if(d1.getTipo() == "Summer" || d2.getTipo() == "Summer"){
          int audio = int(random(1,5));
          if(audio == 1) domino1.trigger();
          if(audio == 2) domino2.trigger();
          if(audio == 3) domino3.trigger();
          else  domino4.trigger();
        }
      }    
    }
    
    if(state == "Summer4" || state == "Summer4.5" || state == "Summer5"){   
      if(d1.getTipo() == "Hielos" && d2.getTipo() == "Hielos"){
        int audio = int(random(1,5));
        if(audio == 1) hielo1.trigger();
        if(audio == 2) hielo2.trigger();
        if(audio == 3) hielo3.trigger();
        else  hielo4.trigger();
      }
    } 
  }
  
  if (o1.getClass() == Ball.class || o2.getClass() == Boundary.class) {
    if(state == "Winter1.5"){
      salto = true;
    }
  }
  if (o1.getClass() == Boundary.class || o2.getClass() == Ball.class) {
    if(state == "Winter1.5"){
      salto = true;
    }
  }
  
  //Bola y copos
  if (o1.getClass() == Ball.class && o2.getClass() == Fijo.class || o1.getClass() == Fijo.class && o2.getClass() == Ball.class) {
    if(state == "Winter1.5"){
      bolaInt1.applyForce(new Vec2(-100,0));
    }
  }

}



//Eventos Telefono ----------------------------------------------------------------------------------------------------------------

void onAttitudeEvent(String ipAddress, float newRoll, float newPitch, float newYaw)
{
  
  if(state == "Fall1"){
    Vec2 fuerza = new Vec2(newYaw*100,0);
    bolaInt1.applyForce(fuerza);
    r = newYaw*200;
    if(r > 500 || r < -500){
      t.makeVibrate();
    }
  }
  
  if(state == "Winter1.5" ){
    if(!salto){ 
      Vec2 fuerza = new Vec2(abs(newRoll*1000),0);
      bolaInt2.applyForce(fuerza);
    }
  }
}

void onTouchDragEvent(String ipAddress, int x,int y){
 if(state == "Fall2" || state == "Fall2.5"){
   if(deslizar > y){
    float suma = map(y, 0, heightStage, 877, 1243 );
    domIntY = suma;
    domInt1.setPos(domIntX, domIntY);
   }
   else{
    return; 
   }
 }
 

 if(state== "Spring3" || state == "Spring3.5"){
   if(deslizar > x){
    float suma = map(x, 0, widthStage, 2526, widthStage);
    domInt2X = suma;
    domInt2.setPos(domInt2X, domInt2Y);
   }
   else{
    return; 
   }
 }
}

void onTouchDownEvent(String ipAddress, int x, int y){
  if(state== "Fall2" || state == "Fall2.5"){
    deslizar = y;
    t.makeVibrate();
  }
  
  if(state== "Spring3" || state == "Spring3.5"){
    deslizar = x;
    t.makeVibrate();
  }
}

void onTouchEvent(String ipAddress, int x, int y) {
  if (escenario == 1) {
    playMusicaJuego();
    escenario = 2;
    state = "Fall1";
  }
  if(state == "Winter1.5"){
    if(salto){
     Vec2 fuerza = new Vec2(500,30000);
     bolaInt2.applyForce(fuerza);
     salto = false;
    }
  }

}
