<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateJuncaceaeTable extends Migration {

	public function up()
	{
		Schema::create('Juncaceae', function(Blueprint $table) {
			$table->string('species_name');
			$table->string('family_name');
			$table->string('inflorescence');
			$table->smallInteger('heads');
			$table->smallInteger('flowers_per_head');
			$table->string('capsule_apex');
		});
	}

	public function down()
	{
		Schema::drop('Juncaceae');
	}
}