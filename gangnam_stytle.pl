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

use constant {
	INDEX_NOMBRE_PROY             => 0,
	INDEX_SIGLAS                  => 1,
	INDEX_RESUMEN                 => 2,
	INDEX_OBJETIVO                => 3,
	INDEX_COSTO                   => 4,
	INDEX_PERIODO                 => 5,
	INDEX_ESTRUCTURA_SECTORIAL    => 0,
	INDEX_ESTRUCTURA_NO_SECTORIAL => 1,
	INDEX_EJE                     => 2,
	INDEX_TEMA                    => 3
};

my $logger;
my $sel;
my $dominio;
my @datos_registro;
my @datos_alineacion;

my $auto_close               = 0;
my $archivo_datos_registro   = "gangnam.csv";
my $archivo_datos_alineacion = "style.csv";
my $pag_login                = "login.jsp";
my $pag_registro             = "registrar-proyecto";
my $indice_prueba            = 0;

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

tie @datos_registro, 'Tie::Array::CSV',
  { file => $archivo_datos_registro, binary => 1 };
tie @datos_alineacion, 'Tie::Array::CSV',
  { file => $archivo_datos_alineacion, binary => 1 };
$logger->trace( "el archivo de mierda es " . Dumper \@datos_registro );

$dominio = "localhost:8080/bespcaca";

#$sel->set_implicit_wait_timeout(10000);

$sel->get( "http://" . $dominio . "/" . $pag_login );

#http://148.204.56.138:8094/besp1/
#busca un elemento html por nombre
#send_keys setea el valor al campo que se esta manejando
$sel->find_element("//input[\@name='userId']")->send_keys("coor");

$sel->find_element("//input[\@name='password']")->send_keys("coor");

$sel->find_element("//input[\@id='votoLatino']")->click;

$sel->find_element("//a[\@id='lnkRegistrarProyecto']")->click;

for (
	$indice_prueba = 1 ;
	$indice_prueba < scalar(@datos_registro) ;
	$indice_prueba++
  )
{
	my @fila_alineacion = $datos_alineacion[$indice_prueba];
	my @fila_registro   = $datos_registro[$indice_prueba];

	$logger->debug("Fuck");

	$sel->find_element("//input[\@name='model.nombre']")
	  ->send_keys( $fila_registro[ (INDEX_NOMBRE_PROY) ] );

	$sel->find_element("//input[\@name='model.siglas']")
	  ->send_keys( $fila_registro[INDEX_SIGLAS] );

	$sel->find_element("//textarea[\@name='model.resumen']")
	  ->send_keys( $fila_registro[INDEX_RESUMEN] );

	$sel->find_element("//textarea[\@name='model.objetivoGeneral']")
	  ->send_keys( $fila_registro[INDEX_OBJETIVO] );

	$sel->find_element("//input[\@name='model.costoTotal']")
	  ->send_keys( $fila_registro[INDEX_COSTO] );

	$sel->find_element("//input[\@id='indefinido']")->click;

	$sel->find_element("//input[\@id='btnAceptar']")->click;

	#boton de alinear proyecto
	$sel->find_element("//a[\@id='btnEditar']")->click;

	if ( $fila_alineacion[INDEX_ESTRUCTURA_SECTORIAL] ) {

		#check para activar la agenda ambiental(programa sectorial)
		$sel->find_element("//input[\@name='alineacionSectorial']")->click;
	}
	if ( $fila_alineacion[INDEX_ESTRUCTURA_NO_SECTORIAL] ) {
		$sel->find_element("//input[\@name='alineacion']")->click;
	}

	sleep 20;
}

$sel->close();

