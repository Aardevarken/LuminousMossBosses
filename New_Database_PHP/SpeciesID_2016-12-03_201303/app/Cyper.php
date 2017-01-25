<?php

namespace Field Guide;

use Illuminate\Database\Eloquent\Model;

class Cyper extends Model {

	protected $table = 'Cyperaceae';
	public $timestamps = false;

	public function cyper_to_famname()
	{
		return $this->hasMany('Famname', 'family_name');
	}

}