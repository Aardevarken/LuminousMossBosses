<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreatePoaceaeTable extends Migration {

	public function up()
	{
		Schema::create('Poaceae', function(Blueprint $table) {
			$table->string('species_name');
			$table->string('family_name');
			$table->string('inflorescence');
			$table->smallInteger('florets_per_spikelet');
			$table->string('awns');
			$table->string('lemma_apex');
		});
	}

	public function down()
	{
		Schema::drop('Poaceae');
	}
}