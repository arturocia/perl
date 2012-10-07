#!/usr/bin/perl -w

use strict;
use diagnostics;
use warnings;
use Selenium::Remote::Driver;
use Selenium::Remote::WebElement;
use Log::Log4perl;
use Log::Log4perl::Layout::XMLLayout;
use Data::Dumper;
use Error qw(:try);
use Tie::Array::CSV;
use Trapper;

my $logger;
my $sel;
my $url;
my @datos_prueba;

my $auto_close             = 0;
my $archivo_datos_registro = "gangnam.csv";

Log::Log4perl::init("./caca.properties");
tie *STDERR, "Trapper";
tie *STDOUT, "Trapper";
$logger =
  Log::Log4perl->get_logger(
	"mx::BBVA::CCR::Intranet::BitacoraProduccion::Batch::Carga");
$logger->trace("La reconcha de la madre");

try {
	$sel = Selenium::Remote::Driver->new(
		remote_server_addr => "localhost",
		port               => 4444,
		browser_name       => "firefox",
		auto_close         => $auto_close
	);
  }
  catch Error with {
	my $ex = shift;
	$logger->warn(
"oppa gangnam style, no se encontro arriba el servidor, se tendra que levantar\n$ex"
	);
  };

if ( !$sel ) {
	system("nohup java -jar selenium-server-standalone.jar > /dev/null &");
	sleep(7);
	try {
		$sel = Selenium::Remote::Driver->new(
			remote_server_addr => "localhost",
			port               => 4444,
			browser_name       => "firefox",
			auto_close         => $auto_close
		);
	  }
	  catch Error with {
		my $ex = shift;
		$logger->error(
			"no se pudo levantar el servidor,alguna mierda paso\n$ex");
	  };
}

$url = "http://localhost:8080/bespcaca/login.jsp";

tie @datos_prueba, 'Tie::Array::CSV',
  { file => $archivo_datos_registro, binary => 1 };
$logger->trace( "el archivo de mierda es " . Dumper \@datos_prueba );

exit;

$sel->get($url);

#http://148.204.56.138:8094/besp1/
#busca un elemento html por nombre
#send_keys setea el valor al campo que se esta manejando
$sel->find_element("//input[\@name='userId']")->send_keys("coor");

$sel->find_element("//input[\@name='password']")->send_keys("coor");

$sel->find_element("//input[\@name='yo']")->click;

$sel->get("http://localhost:8081/bespPuta/registrar-proyecto/");

$sel->find_element("//input[\@name='model.nombre']")
  ->send_keys("Proyecto MASIOSARE");

$sel->find_element("//input[\@name='model.siglas']")->send_keys("PM");

$sel->find_element("//textarea[\@name='model.resumen']")
  ->send_keys("Proyectoestrella");

$sel->find_element("//textarea[\@name='model.objetivoGeneral']")
  ->send_keys("Registrar un nuevo proyecto");

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

