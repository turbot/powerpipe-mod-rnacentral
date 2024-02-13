dashboard "rna_analysis_dashboard" {
  title = "RNAcentral Analysis Dashboard"

  # Container: Overview
  container {
    title = "Overview"

    # Card: Total Chemical Components
    card {
      query = query.total_chemical_components
      width = 4
      type  = "info"
    }

    # Card: Total Databases
    card {
      query = query.total_databases
      width = 4
      type  = "info"
    }

    # Card: Total Interactions
    card {
      query = query.total_interactions
      width = 4
      type  = "info"
    }
  }

  container {
    title = "Database Analysis"

    chart {
      type  = "donut"
      title = "Databases by Number of Organisms"
      query = query.databases_by_num_organisms
      width = 6
    }

    chart {
      type  = "donut"
      title = "Databases by Number of Sequences"
      query = query.databases_by_num_sequences
      width = 6
    }
  }

  container {
    title = "Chemical Component Analysis"
    width = 6

    chart {
      query = query.chemical_components_distribution
      title = "Chemical Components Distribution by Source"
      type  = "donut"
    }
  }

  container {
    title = "Sequence Analysis"
    width = 6

    chart {
      query = query.modifications_distribution
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
      query = query.interactions_by_taxid
      width = 6
      title = "Interactions by Taxonomic ID"
      type  = "column"
    }

    chart {
      type  = "column"
      title = "Top 10 Entities by Unique Interactions"
      query = query.unique_interactions_per_interacting_id
      width = 6

      series "Unique Interactions" {
        title = "Unique Interactions"
        color = "green"
      }
    }

    chart {
      query = query.feedback_overlap_analysis
      width = 6
      title = "Feedback Overlap Analysis"
      type  = "column"
    }

    chart {
      type  = "column"
      title = "Assemblies by Feedback Count"
      query = query.feedback_distribution_by_assembly
      width = 6

      series "Feedback Count" {
        title = "Feedback Count"
        color = "darkblue"
      }
    }
  }
}

query "feedback_distribution_by_assembly" {
  sql = <<-EOQ
    select
      assembly_id AS "Assembly ID",
      count(*) AS "Feedback Count"
    from
      rnacen.rnc_feedback_target_assemblies
    group by
      assembly_id;
  EOQ
}

query "unique_interactions_per_interacting_id" {
  sql = <<-EOQ
    select
      interacting_id AS "Interacting ID",
      count(DISTINCT intact_id) AS "Unique Interactions"
    from
      rnacen.rnc_interactions
    group by
      interacting_id
    order by
      "Unique Interactions" DESC
    limit 10;
  EOQ
}

query "interactions_by_taxid_distribution" {
  sql = <<-EOQ
    select
      taxid AS "Taxonomic ID",
      count(*) AS "Number of Interactions"
    from
      rnacen.rnc_interactions
    group by
      taxid
    order by
      "Number of Interactions" DESC
    limit 10;
  EOQ
}

query "databases_by_num_sequences" {
  sql = <<-EOQ
    select
      display_name AS "Database",
      num_sequences AS "Number of Sequences"
    from
      rnacen.rnc_database;
  EOQ
}

query "databases_by_num_organisms" {
  sql = <<-EOQ
    select
      display_name AS "Database",
      num_organisms AS "Number of Organisms"
    from
      rnacen.rnc_database;
  EOQ
}

# Sample queries based on the available tables
query "total_chemical_components" {
  sql = <<-EOQ
    select count(*) AS "Total Chemical Components"
    from rnacen.rnc_chemical_components;
  EOQ
}

query "total_databases" {
  sql = <<-EOQ
    select count(*) AS "Total Databases"
    from rnacen.rnc_database;
  EOQ
}

query "total_interactions" {
  sql = <<-EOQ
    select count(*) AS "Total Interactions"
    from rnacen.rnc_interactions;
  EOQ
}

query "database_size_comparison" {
  sql = <<-EOQ
    select
      display_name AS "Database",
      num_sequences,
      num_organisms
    from
      rnacen.rnc_database;
  EOQ
}

query "coding_probability_vs_fickett_score" {
  sql = <<-EOQ
    select
      coding_probability,
      fickett_score
    from
      rnacen.rnc_cpat_results
    WHERE
      coding_probability IS NOT NULL AND
      fickett_score IS NOT NULL;
  EOQ
}

query "modifications_distribution" {
  sql = <<-EOQ
    select
      modification_id,
      count(*) AS "num_modifications"
    from
      rnacen.rnc_modifications
    group by
      modification_id
    order by
      "num_modifications" DESC
    limit 10;
  EOQ
}

query "chemical_components_distribution" {
  sql = <<-EOQ
    select
      source,
      count(*) AS "Count"
    from
      rnacen.rnc_chemical_components
    group by
      source
    order by
      "Count" DESC;
  EOQ
}

query "interactions_by_taxid" {
  sql = <<-EOQ
    select
      taxid,
      count(*) AS "Number of Interactions"
    from
      rnacen.rnc_interactions
    group by
      taxid;
  EOQ
}

query "feedback_overlap_analysis" {
  sql = <<-EOQ
    select
      assembly_id,
      count(*) FILTER (WHERE should_ignore = false) AS "Relevant Feedbacks",
      count(*) FILTER (WHERE should_ignore = true) AS "Ignored Feedbacks"
    from
      rnacen.rnc_feedback_overlap
    group by
      assembly_id;
  EOQ
}
