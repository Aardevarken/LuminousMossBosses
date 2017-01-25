<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateFamilyNameFilterTable extends Migration {

	public function up()
	{
		Schema::create('Family_Name_Filter', function(Blueprint $table) {
			$table->string('species_name');
			$table->string('family_name');
		});
	}

	public function down()
	{
		Schema::drop('Family_Name_Filter');
	}
}