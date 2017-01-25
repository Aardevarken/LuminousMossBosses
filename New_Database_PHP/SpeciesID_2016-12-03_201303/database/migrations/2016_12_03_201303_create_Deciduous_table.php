<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateDeciduousTable extends Migration {

	public function up()
	{
		Schema::create('Deciduous', function(Blueprint $table) {
			$table->string('species_name');
			$table->string('family_name');
			$table->string('leaf_type');
			$table->string('leaf_margin');
			$table->string('leaf_shape');
			$table->string('leaf_arrangement');
		});
	}

	public function down()
	{
		Schema::drop('Deciduous');
	}
}