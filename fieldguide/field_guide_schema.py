#!/usr/bin/python

from FieldGuideParser import FieldGuideParser
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, Table
from sqlalchemy.orm import sessionmaker, relationship, backref
from sqlalchemy.ext.declarative import declarative_base
import os, sys

db_name = 'FieldGuide.db'

# if os.path.exists(db_name):
# 	os.remove(db_name)

engine = create_engine('sqlite:///' + db_name)
Session = sessionmaker(bind=engine)()

Base = declarative_base()


# class SpeciesPicture(Base):
# 	__tablename__ = 'speciespicture'
# 	id = Column(Integer, primary_key=True)
# 	species_id = Column(Integer, ForeignKey('species.id'))
# 	name = Column(String)


class Synonym(Base):
	__tablename__ = 'synonym'
	id = Column(Integer, primary_key=True)
	species_id = Column(Integer, ForeignKey('species.id'))
	name = Column(String)

class CF(Base):
	__tablename__ = 'cf'
	id = Column(Integer, primary_key=True)
	species_id = Column(Integer, ForeignKey('species.id'))
	name = Column(String)

class LeafShapeFilter(Base):
	__tablename__ = 'leafshapefilter'
	id = Column(Integer, primary_key=True)
	name = Column(String)
	picture_filename = Column(String)

species_growthform_table = Table('species_growthform', Base.metadata,
	Column('species_id', Integer, ForeignKey('species.id')),
	Column('growthform_id', Integer, ForeignKey('growthform.id'))
)

class GrowthForm(Base):
	__tablename__ = 'growthform'
	id = Column(Integer, primary_key=True)
	name = Column(String)


species_flowercolor_table = Table('species_flowercolor', Base.metadata,
	Column('species_id', Integer, ForeignKey('species.id')),
	Column('flowercolor_id', Integer, ForeignKey('flowercolor.id'))
)

class FlowerColor(Base):
	__tablename__ = 'flowercolor'
	id = Column(Integer, primary_key=True)
	name = Column(String)


species_inflorescence_table = Table('species_inflorescence', Base.metadata,
	Column('species_id', Integer, ForeignKey('species.id')),
	Column('inflorescence_id', Integer, ForeignKey('inflorescence.id'))
)

class Inflorescence(Base):
	__tablename__ = 'inflorescence'
	id = Column(Integer, primary_key=True)
	name = Column(String)
	picture_filename = Column(String)


species_flowershape_table = Table('species_flowershape', Base.metadata,
	Column('species_id', Integer, ForeignKey('species.id')),
	Column('flowershape_id', Integer, ForeignKey('flowershape.id'))
)

class FlowerShape(Base):
	__tablename__ = 'flowershape'
	id = Column(Integer, primary_key=True)
	name = Column(String)
	picture_filename = Column(String)


species_petalnumber_table = Table('species_petalnumber', Base.metadata,
	Column('species_id', Integer, ForeignKey('species.id')),
	Column('petalnumber_id', Integer, ForeignKey('petalnumber.id'))
)

class PetalNumber(Base):
	__tablename__ = 'petalnumber'
	id = Column(Integer, primary_key=True)
	name = Column(String)


species_leafarrangement_table = Table('species_leafarrangement', Base.metadata,
	Column('species_id', Integer, ForeignKey('species.id')),
	Column('leafarrangement_id', Integer, ForeignKey('leafarrangement.id'))
)

class LeafArrangement(Base):
	__tablename__ = 'leafarrangement'
	id = Column(Integer, primary_key=True)
	name = Column(String)
	picture_filename = Column(String)


species_leafshape_table = Table('species_leafshape', Base.metadata,
	Column('species_id', Integer, ForeignKey('species.id')),
	Column('leafshape_id', Integer, ForeignKey('leafshape.id'))
)

class LeafShape(Base):
	__tablename__ = 'leafshape'
	id = Column(Integer, primary_key=True)
	name = Column(String)
	picture_filename = Column(String)


species_habitat_table = Table('species_habitat', Base.metadata,
	Column('species_id', Integer, ForeignKey('species.id')),
	Column('habitat_id', Integer, ForeignKey('habitat.id'))
)

class Habitat(Base):
	__tablename__ = 'habitat'
	id = Column(Integer, primary_key=True)
	name = Column(String)

class Species(Base):
	__tablename__ = 'species'
	id = Column(Integer, primary_key=True)
	growthform_id = Column(Integer, ForeignKey('growthform.id'))
	growthform = relationship ("GrowthForm")
	code = Column(String)
	binomial_name = Column(String)
	common_name = Column(String)
	family = Column(String)
	synonyms = relationship("Synonym")
	description = Column(String)
	flowercolor = relationship ("FlowerColor", secondary = species_flowercolor_table)
	flowershape = relationship ("FlowerShape", secondary = species_flowershape_table)
	petalnumber = relationship ("PetalNumber", secondary = species_petalnumber_table)
	inflorescence = relationship ("Inflorescence", secondary = species_inflorescence_table)
	leafarrangement = relationship ("LeafArrangement", secondary = species_leafarrangement_table)
	leafshape = relationship ("LeafShape", secondary = species_leafshape_table)
	leafshapefilter_id = Column(Integer, ForeignKey('leafshapefilter.id'))
	leafshapefilter = relationship('LeafShapeFilter')
	habitat = relationship ("Habitat", secondary = species_habitat_table)
	cf = relationship("CF")
	# speciespicture = relationship ("SpeciesPicture")

	def speciesInitErrorOut(self,tablename, itemname):
		print "error: " + self.binomial_name + ": '" + itemname + "' does not exist in the " + tablename + " table. Check spelling or add to glossary"
		sys.exit(1)

	def __init__(self, growthform, code, binomial_name, common_name, family, synonyms, description, flowercolor, flowershape, petalnumber, 
		inflorescence, leafarrangement, leafshape, leafshapefilter, habitat, cf):
		self.growthform = Session.query(GrowthForm).filter_by(name=growthform).first()
		self.code = code
		self.binomial_name = binomial_name
		self.common_name = common_name
		self.family = family

		for s in synonyms.split(','):
			self.synonyms.append(Synonym(name = s))

		self.description = description

		for fc in flowercolor.split(','):
			fc = fc.strip()
			fc_object = Session.query(FlowerColor).filter_by(name = fc.strip()).first()
			if (fc_object): self.flowercolor.append(fc_object)
			else:
				if fc not in ['.', '']: self.speciesInitErrorOut("flowercolor", fc)

		for fs in flowershape.split(','):
			fs = fs.strip()
			fs_object = Session.query(FlowerShape).filter_by(name = fs.strip()).first()
			if (fs_object): self.flowershape.append(fs_object)
			else:
				if fs not in ['.', '']: self.speciesInitErrorOut("flowershape", fs)

		for pn in petalnumber.split(','):
			pn = pn.strip()
			pn_object = Session.query(PetalNumber).filter_by(name = pn).first()
			if (pn_object): self.petalnumber.append(pn_object)
			else: 
				if pn not in ['.', '']: self.speciesInitErrorOut("petalnumber", pn)


		for i in inflorescence.split(','):
			i = i.strip()
			i_object = Session.query(Inflorescence).filter_by(name = i).first()
			if (i_object): self.inflorescence.append(i_object)
			else: 
				if i not in ['.', '']: self.speciesInitErrorOut("inflorescence", i)

		for la in leafarrangement.split(','):
			la = la.strip()
			la_object = Session.query(LeafArrangement).filter_by(name = la).first()
			if (la_object): self.leafarrangement.append(la_object)
			else: 
				if la not in ['.', '']: self.speciesInitErrorOut("leafarrangement", la)

		for ls in leafshape.split(','):
			ls = ls.strip()
			ls_object = Session.query(LeafShape).filter_by(name = ls).first()
			if (ls_object): self.leafshape.append(ls_object)
			else: 
				if ls not in ['.','']: self.speciesInitErrorOut("leafshape", ls)

		lsf_object = Session.query(LeafShapeFilter).filter_by(name = leafshapefilter).first()
		if (lsf_object): self.leafshapefilter = lsf_object
		else:
			if leafshapefilter not in ['.', '']: self.speciesInitErrorOut("leafshapefilter", leafshapefilter)

		for h in habitat.split(','):
			h = h.strip()
			h_object = Session.query(Habitat).filter_by(name = h).first()
			if (h_object): self.habitat.append(h_object)
			else: 
				if h not in ['.', '']: self.speciesInitErrorOut("habitat", h)

		for c in cf.split(','):
			if c.strip() not in  ['.', '']: self.cf.append(CF(name = c.strip()))

Base.metadata.drop_all(engine)
Base.metadata.create_all(engine)	
Session.commit()


glossary_terms = FieldGuideParser.parseGlossaryTerms('GlossaryTerms.csv')
for table_name in glossary_terms:
	for term in glossary_terms[table_name]:
		table_class = eval("".join(table_name.title().split())) #the eval expression turns the table name into the relavant class
		if hasattr(table_class, 'picture_filename'):
			row = table_class(name=term, picture_filename = term+'.jpeg')
		else:
			row = table_class(name=term)
		Session.add(row)

for forb in FieldGuideParser.parseForbsSpecies('Forbs.csv'):
	if len(forb) != 16:
		print "error: incorrect number of columns in input (" + str(len(forb)) + "). This program will need to be updated in order to handle more/less columns"
		sys.exit()
	else:
		row = Species(*forb)
		Session.add(row)

Session.commit()