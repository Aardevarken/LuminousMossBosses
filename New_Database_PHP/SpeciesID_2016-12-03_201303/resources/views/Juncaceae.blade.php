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
			{!! Form::label('inflorescence', 'Inflorescence:') !!}
			{!! Form::text('inflorescence') !!}
		</li>
		<li>
			{!! Form::label('heads', 'Heads:') !!}
			{!! Form::text('heads') !!}
		</li>
		<li>
			{!! Form::label('flowers_per_head', 'Flowers_per_head:') !!}
			{!! Form::text('flowers_per_head') !!}
		</li>
		<li>
			{!! Form::label('capsule_apex', 'Capsule_apex:') !!}
			{!! Form::text('capsule_apex') !!}
		</li>
		<li>
			{!! Form::submit() !!}
		</li>
	</ul>
{!! Form::close() !!}