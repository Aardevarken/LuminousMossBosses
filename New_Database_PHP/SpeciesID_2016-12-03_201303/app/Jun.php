<?php

namespace Field Guide;

use Illuminate\Database\Eloquent\Model;

class Jun extends Model {

	protected $table = 'Juncaceae';
	public $timestamps = false;

	public function jun_to_famname()
	{
		return $this->hasMany('Famname', 'family_name');
	}

}