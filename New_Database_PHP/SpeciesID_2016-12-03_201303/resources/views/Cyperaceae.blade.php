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
			{!! Form::label('spikes', 'Spikes:') !!}
			{!! Form::text('spikes') !!}
		</li>
		<li>
			{!! Form::label('spike_color', 'Spike_color:') !!}
			{!! Form::text('spike_color') !!}
		</li>
		<li>
			{!! Form::label('terminal_spike_sex', 'Terminal_spike_sex:') !!}
			{!! Form::text('terminal_spike_sex') !!}
		</li>
		<li>
			{!! Form::label('subtending_spike_sex', 'Subtending_spike_sex:') !!}
			{!! Form::text('subtending_spike_sex') !!}
		</li>
		<li>
			{!! Form::label('scale_apex', 'Scale_apex:') !!}
			{!! Form::text('scale_apex') !!}
		</li>
		<li>
			{!! Form::label('scale_length', 'Scale_length:') !!}
			{!! Form::text('scale_length') !!}
		</li>
		<li>
			{!! Form::label('perigynium', 'Perigynium:') !!}
			{!! Form::text('perigynium') !!}
		</li>
		<li>
			{!! Form::label('stigmas', 'Stigmas:') !!}
			{!! Form::text('stigmas') !!}
		</li>
		<li>
			{!! Form::submit() !!}
		</li>
	</ul>
{!! Form::close() !!}