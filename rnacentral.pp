dashboard "rnacentral" {
  title = "RNAcentral Dashboard"
  documentation = file("./docs/rnacentral.md")

  container {
    title = "Overview"

    card {
      query = query.rnacentral_total_chemical_components
      width = 4
      type  = "info"
    }

    card {
      query = query.rnacentral_total_databases
      width = 4
      type  = "info"
    }

    card {
      query = query.rnacentral_total_interactions
      width = 4
      type  = "info"
    }
  }

  container {
    title = "Database Analysis"

    chart {
      type  = "pie"
      title = "Databases by Number of Organisms"
      query = query.rnacentral_databases_by_num_organisms
      width = 6
    }

    chart {
      type  = "donut"
      title = "Databases by Number of Sequences"
      query = query.rnacentral_databases_by_num_sequences
      width = 6
    }
  }

  container {
    title = "Chemical Component Analysis"
    width = 6

    chart {
      query = query.rnacentral_chemical_components_distribution
      title = "Chemical Components Distribution by Source"
      type  = "donut"
    }
  }

  container {
    title = "Sequence Analysis"
    width = 6

    chart {
      query = query.rnacentral_modifications_distribution
      title = "RNA Modifications Distribution"
      type  = "column"

      series "num_modifications" {
        title = "Number of Modifications"
        color = "purple"
      }
    }
  }

  container {
    title = "Interaction and Feedback Analysis"

    chart {
      query = query.rnacentral_interactions_by_taxid
      width = 6
      title = "Interactions by Taxonomic ID"
      type  = "column"
    }

    chart {
      type  = "column"
      title = "Top 10 Entities by Unique Interactions"
      query = query.rnacentral_unique_interactions_per_interacting_id
      width = 6

      series "Unique Interactions" {
        title = "Unique Interactions"
        color = "green"
      }
    }

    chart {
      query = query.rnacentral_feedback_overlap_analysis
      width = 6
      title = "Feedback Overlap Analysis"
      type  = "column"
    }

    chart {
      type  = "column"
      title = "Assemblies by Feedback Count"
      query = query.rnacentral_feedback_distribution_by_assembly
      width = 6

      series "Feedback Count" {
        title = "Feedback Count"
        color = "darkblue"
      }
    }
  }
}

# Card Queries

query "rnacentral_total_chemical_components" {
  sql = <<-EOQ
    select
      count(*) as "Total Chemical Components"
    from
      rnacen.rnc_chemical_components;
  EOQ
}

query "rnacentral_total_databases" {
  sql = <<-EOQ
    select
      count(*) as "Total Databases"
    from
      rnacen.rnc_database;
  EOQ
}

query "rnacentral_total_interactions" {
  sql = <<-EOQ
    select
      count(*) as "Total Interactions"
    from
      rnacen.rnc_interactions;
  EOQ
}

# Chart Queries

query "rnacentral_databases_by_num_organisms" {
  sql = <<-EOQ
    select
      display_name as "Database",
      num_organisms as "Number of Organisms"
    from
      rnacen.rnc_database
    order by
      num_organisms desc;
  EOQ
}

query "rnacentral_databases_by_num_sequences" {
  sql = <<-EOQ
    select
      display_name as "Database",
      num_sequences as "Number of Sequences"
    from
      rnacen.rnc_database
    order by
      num_sequences desc;
  EOQ
}

query "rnacentral_chemical_components_distribution" {
  sql = <<-EOQ
    select
      source,
      count(*) as "Count"
    from
      rnacen.rnc_chemical_components
    group by
      source
    order by
      "Count" desc;
  EOQ
}

query "rnacentral_modifications_distribution" {
  sql = <<-EOQ
    select
      modification_id,
      count(*) as "num_modifications"
    from
      rnacen.rnc_modifications
    group by
      modification_id
    order by
      "num_modifications" desc
    limit 10;
  EOQ
}

query "rnacentral_interactions_by_taxid" {
  sql = <<-EOQ
    select
      taxid,
      count(*) as "Number of Interactions"
    from
      rnacen.rnc_interactions
    group by
      taxid
    order by
      "Number of Interactions" desc;
  EOQ
}

query "rnacentral_unique_interactions_per_interacting_id" {
  sql = <<-EOQ
    select
      interacting_id as "Interacting ID",
      count(DISTINCT intact_id) as "Unique Interactions"
    from
      rnacen.rnc_interactions
    group by
      interacting_id
    order by
      "Unique Interactions" desc
    limit 10;
  EOQ
}

query "rnacentral_feedback_overlap_analysis" {
  sql = <<-EOQ
    select
      assembly_id,
      count(*) FILTER (where should_ignore = false) as "Relevant Feedbacks",
      count(*) FILTER (where should_ignore = true) as "Ignored Feedbacks"
    from
      rnacen.rnc_feedback_overlap
    group by
      assembly_id;
  EOQ
}

query "rnacentral_feedback_distribution_by_assembly" {
  sql = <<-EOQ
    select
      assembly_id as "Assembly ID",
      count(*) as "Feedback Count"
    from
      rnacen.rnc_feedback_target_assemblies
    group by
      assembly_id
    order by
      "Feedback Count" desc;
  EOQ
}