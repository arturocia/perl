#!/usr/bin/perl -w

use strict;
use Selenium::Remote::Driver;
use Selenium::Remote::WebElement;

my $sel = Selenium::Remote::Driver->new( remote_server_addr => "localhost",
                                        port => 4444,
                                        browser_name => "firefox");

$sel->get("http://localhost:8081/bespPuta/login.jsp");

#busca un elemento html por nombre
#send_keys setea el valor al campo que se esta manejando
 $sel->find_element("//input[\@name='userId']")->send_keys("coor");

 $sel->find_element("//input[\@name='password']")->send_keys("coor");

 $sel->find_element("//input[\@name='yo']")->click;
      
 $sel->get("http://localhost:8081/bespPuta/registrar-proyecto/");

 $sel->find_element("//input[\@name='model.nombre']")->send_keys("Proyecto MASIOSARE");
 
 $sel->find_element("//input[\@name='model.siglas']")->send_keys("PM");

 $sel->find_element("//textarea[\@name='model.resumen']")->send_keys("Proyectoestrella");

 $sel->find_element("//textarea[\@name='model.objetivoGeneral']")->send_keys("Registrar un nuevo proyecto");
 
 $sel->find_element("//input[\@name='model.costoTotal']")->send_keys("1005000");

 $sel->find_element("//input[\@id='indefinido']")->click;
 

 $sel->find_element("//input[\@id='btnAceptar']")->click;

 #boton de alinear proyecto
 $sel->find_element("//a[\@id='btnEditar']")->click;
 
 sleep 5;

 #check para activar la agenda ambiental(programa sectorial)
 $sel->find_element("//input[\@name='alineacionSectorial']")->click;

 $sel->find_element("//CSS[\@jstree-icon ui-icon ui-icon-triangle-1-e']")->click;

 sleep 20;

 $sel->close(); 


