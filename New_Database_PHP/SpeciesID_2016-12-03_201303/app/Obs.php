<?php

namespace GPS Observations;

use Illuminate\Database\Eloquent\Model;

class Obs extends Model {

	protected $table = 'Observations';
	public $timestamps = false;

	public function obs_to_acc()
	{
		return $this->hasOne('Acc', 'user_name');
	}

	public function obs_to_specie()
	{
		return $this->hasOne('Snames', 'species_name');
	}

}