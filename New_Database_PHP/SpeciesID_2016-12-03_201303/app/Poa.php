<?php

namespace Field Guide;

use Illuminate\Database\Eloquent\Model;

class Poa extends Model {

	protected $table = 'Poaceae';
	public $timestamps = false;

	public function poa_to_famname()
	{
		return $this->hasMany('Famname', 'family_name');
	}

}