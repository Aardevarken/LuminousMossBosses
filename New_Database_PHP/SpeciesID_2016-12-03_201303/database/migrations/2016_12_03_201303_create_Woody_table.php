<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateWoodyTable extends Migration {

	public function up()
	{
		Schema::create('Woody', function(Blueprint $table) {
			$table->string('species_name');
			$table->string('leaft_type');
		});
	}

	public function down()
	{
		Schema::drop('Woody');
	}
}