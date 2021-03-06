CREATE OR REPLACE VIEW :cdm_schema.f_observation_view
AS SELECT measurement.measurement_id AS observation_id,
    measurement.person_id,
    measurement.measurement_concept_id AS observation_concept_id,
    measurement.measurement_date AS observation_date,
    measurement.measurement_datetime AS observation_datetime,
    measurement.measurement_time AS observation_time,
    measurement.measurement_type_concept_id AS observation_type_concept_id,
    measurement.operator_concept_id AS observation_operator_concept_id,
    measurement.value_as_number,
    NULL::character varying AS value_as_string,
    measurement.value_as_concept_id,
    NULL::integer AS qualifier_concept_id,
    measurement.unit_concept_id,
    measurement.range_low,
    measurement.range_high,
    measurement.provider_id,
    measurement.visit_occurrence_id,
    measurement.measurement_source_value AS observation_source_value,
    measurement.measurement_source_concept_id AS observation_source_concept_id,
    measurement.unit_source_value,
    measurement.value_source_value,
    NULL::character varying AS qualifier_source_value
   FROM :cdm_schema.measurement
UNION ALL
 SELECT - observation.observation_id AS observation_id,
    observation.person_id,
    observation.observation_concept_id,
    observation.observation_date,
    observation.observation_datetime,
    observation.observation_date::character varying AS observation_time,
    observation.observation_type_concept_id,
    NULL::integer AS observation_operator_concept_id,
    observation.value_as_number,
    observation.value_as_string,
    observation.value_as_concept_id,
    observation.qualifier_concept_id,
    observation.unit_concept_id,
    NULL::double precision AS range_low,
    NULL::double precision AS range_high,
    observation.provider_id,
    observation.visit_occurrence_id,
    observation.observation_source_value,
    observation.observation_source_concept_id,
    observation.unit_source_value,
    NULL::character varying AS value_source_value,
    observation.qualifier_source_value
   FROM :cdm_schema.observation
  WHERE NOT (observation.observation_concept_id IN ( SELECT c.concept_id
           FROM cdm60.concept c
          WHERE (upper(c.concept_name::text) ~~ '%ALLERG%'::text OR upper(c.concept_name::text) ~~ '%REACTION%'::text) AND (c.domain_id::text = 'Observation'::text OR c.domain_id::text = 'Condition'::text) AND c.invalid_reason::text <> 'D'::text));

