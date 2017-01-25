<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateNeedleTable extends Migration {

	public function up()
	{
		Schema::create('Needle', function(Blueprint $table) {
			$table->string('species_name');
			$table->string('family_name');
			$table->string('leaf_type');
			$table->string('needle_arragement');
			$table->smallInteger('needles_per_fascicle');
			$table->string('needle_apex');
			$table->string('cone');
		});
	}

	public function down()
	{
		Schema::drop('Needle');
	}
}