<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateObservationsTable extends Migration {

	public function up()
	{
		Schema::create('Observations', function(Blueprint $table) {
			$table->string('user_name');
			$table->string('species_name')->unique();
			$table->float('GPS_lat');
			$table->float('GPS_long');
			$table->decimal('GPS_accuracy');
			$table->datetime('date_time');
			$table->text('photo');
			$table->text('comments');
			$table->tinyInteger('is_verified');
		});
	}

	public function down()
	{
		Schema::drop('Observations');
	}
}