<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateSpeciesNamesTable extends Migration {

	public function up()
	{
		Schema::create('Species_names', function(Blueprint $table) {
			$table->string('species_name');
		});
	}

	public function down()
	{
		Schema::drop('Species_names');
	}
}