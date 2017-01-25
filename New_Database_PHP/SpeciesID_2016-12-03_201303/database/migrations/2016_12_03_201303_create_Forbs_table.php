<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateForbsTable extends Migration {

	public function up()
	{
		Schema::create('Forbs', function(Blueprint $table) {
			$table->string('species_name');
			$table->string('family_name');
			$table->string('flower_color');
			$table->string('inflorescence');
			$table->string('flower_shape');
			$table->smallInteger('petal_number');
			$table->string('leaf_arrangement');
			$table->string('leaf_shape');
			$table->string('leaf_shapw_filter');
			$table->string('habitat');
		});
	}

	public function down()
	{
		Schema::drop('Forbs');
	}
}