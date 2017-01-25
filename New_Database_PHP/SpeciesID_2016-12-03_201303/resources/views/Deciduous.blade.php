{!! Form::open(array('route' => 'route.name', 'method' => 'POST')) !!}
	<ul>
		<li>
			{!! Form::label('species_name', 'Species_name:') !!}
			{!! Form::text('species_name') !!}
		</li>
		<li>
			{!! Form::label('family_name', 'Family_name:') !!}
			{!! Form::text('family_name') !!}
		</li>
		<li>
			{!! Form::label('leaf_type', 'Leaf_type:') !!}
			{!! Form::text('leaf_type') !!}
		</li>
		<li>
			{!! Form::label('leaf_margin', 'Leaf_margin:') !!}
			{!! Form::text('leaf_margin') !!}
		</li>
		<li>
			{!! Form::label('leaf_shape', 'Leaf_shape:') !!}
			{!! Form::text('leaf_shape') !!}
		</li>
		<li>
			{!! Form::label('leaf_arrangement', 'Leaf_arrangement:') !!}
			{!! Form::text('leaf_arrangement') !!}
		</li>
		<li>
			{!! Form::submit() !!}
		</li>
	</ul>
{!! Form::close() !!}