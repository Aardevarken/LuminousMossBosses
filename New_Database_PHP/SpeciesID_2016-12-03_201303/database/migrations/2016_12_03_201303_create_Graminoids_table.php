<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateGraminoidsTable extends Migration {

	public function up()
	{
		Schema::create('Graminoids', function(Blueprint $table) {
			$table->string('species_name');
			$table->string('family_name');
			$table->string('stem_cross_section');
			$table->string('growth_form');
			$table->string('leaf_sheath');
			$table->string('leaf_blade');
			$table->string('ligule');
			$table->string('subtrending_bract');
			$table->string('habitat');
		});
	}

	public function down()
	{
		Schema::drop('Graminoids');
	}
}