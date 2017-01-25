{!! Form::open(array('route' => 'route.name', 'method' => 'POST')) !!}
	<ul>
		<li>
			{!! Form::label('species_name', 'Species_name:') !!}
			{!! Form::text('species_name') !!}
		</li>
		<li>
			{!! Form::label('leaft_type', 'Leaft_type:') !!}
			{!! Form::text('leaft_type') !!}
		</li>
		<li>
			{!! Form::submit() !!}
		</li>
	</ul>
{!! Form::close() !!}