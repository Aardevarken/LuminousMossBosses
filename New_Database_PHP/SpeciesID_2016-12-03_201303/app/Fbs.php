<?php

namespace Field Guide;

use Illuminate\Database\Eloquent\Model;

class Fbs extends Model {

	protected $table = 'Forbs';
	public $timestamps = false;

	public function forbs_to_specie()
	{
		return $this->hasMany('Snames', 'species_name');
	}

}