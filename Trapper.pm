	########################################
	package Trapper;
	########################################

	use Log::Log4perl;
	use strict;

	sub TIEHANDLE {
		my $class = shift;
		bless [], $class;
	}

	sub PRINT {
		my $self = shift;
		$Log::Log4perl::caller_depth++;
		my $logger = Log::Log4perl->get_logger(
			"mx::BBVA::CCR::Intranet::Logger")
		  ;
		$logger->error(@_);
		$Log::Log4perl::caller_depth--;
	}

	1;
