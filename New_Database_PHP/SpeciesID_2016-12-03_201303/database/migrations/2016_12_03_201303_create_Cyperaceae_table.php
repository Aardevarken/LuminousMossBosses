<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateCyperaceaeTable extends Migration {

	public function up()
	{
		Schema::create('Cyperaceae', function(Blueprint $table) {
			$table->string('species_name');
			$table->string('family_name');
			$table->string('inflorescence');
			$table->string('spikes');
			$table->string('spike_color');
			$table->string('terminal_spike_sex');
			$table->string('subtending_spike_sex');
			$table->string('scale_apex');
			$table->string('scale_length');
			$table->string('perigynium');
			$table->smallInteger('stigmas');
		});
	}

	public function down()
	{
		Schema::drop('Cyperaceae');
	}
}