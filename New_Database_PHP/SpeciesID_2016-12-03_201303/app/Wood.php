<?php

namespace Field Guide;

use Illuminate\Database\Eloquent\Model;

class Wood extends Model {

	protected $table = 'Woody';
	public $timestamps = false;

	public function woods_to_specie()
	{
		return $this->hasMany('Snames', 'species_name');
	}

}