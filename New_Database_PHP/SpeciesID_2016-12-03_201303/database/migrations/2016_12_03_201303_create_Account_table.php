<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateAccountTable extends Migration {

	public function up()
	{
		Schema::create('Account', function(Blueprint $table) {
			$table->string('user_name');
			$table->string('password');
			$table->string('email');
			$table->boolean('is_researcher');
			$table->boolean('privacy_setting');
			$table->tinyInteger('notification_settings');
			$table->string('signal_strength');
			$table->smallInteger('maps_saved');
		});
	}

	public function down()
	{
		Schema::drop('Account');
	}
}