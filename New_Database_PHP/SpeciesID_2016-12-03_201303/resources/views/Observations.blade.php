{!! Form::open(array('route' => 'route.name', 'method' => 'POST')) !!}
	<ul>
		<li>
			{!! Form::label('user_name', 'User_name:') !!}
			{!! Form::text('user_name') !!}
		</li>
		<li>
			{!! Form::label('species_name', 'Species_name:') !!}
			{!! Form::text('species_name') !!}
		</li>
		<li>
			{!! Form::label('GPS_lat', 'GPS_lat:') !!}
			{!! Form::text('GPS_lat') !!}
		</li>
		<li>
			{!! Form::label('GPS_long', 'GPS_long:') !!}
			{!! Form::text('GPS_long') !!}
		</li>
		<li>
			{!! Form::label('GPS_accuracy', 'GPS_accuracy:') !!}
			{!! Form::text('GPS_accuracy') !!}
		</li>
		<li>
			{!! Form::label('date_time', 'Date_time:') !!}
			{!! Form::text('date_time') !!}
		</li>
		<li>
			{!! Form::label('photo', 'Photo:') !!}
			{!! Form::textarea('photo') !!}
		</li>
		<li>
			{!! Form::label('comments', 'Comments:') !!}
			{!! Form::textarea('comments') !!}
		</li>
		<li>
			{!! Form::label('is_verified', 'Is_verified:') !!}
			{!! Form::text('is_verified') !!}
		</li>
		<li>
			{!! Form::submit() !!}
		</li>
	</ul>
{!! Form::close() !!}