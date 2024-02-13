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
    SELECT
      assembly_id AS "Assembly ID",
      COUNT(*) AS "Feedback Count"
    FROM
      rnacen.rnc_feedback_target_assemblies
    GROUP BY
      assembly_id;
  EOQ
}

query "unique_interactions_per_interacting_id" {
  sql = <<-EOQ
    SELECT
      interacting_id AS "Interacting ID",
      COUNT(DISTINCT intact_id) AS "Unique Interactions"
    FROM
      rnacen.rnc_interactions
    GROUP BY
      interacting_id
    ORDER BY
      "Unique Interactions" DESC
    LIMIT 10;
  EOQ
}

query "interactions_by_taxid_distribution" {
  sql = <<-EOQ
    SELECT
      taxid AS "Taxonomic ID",
      COUNT(*) AS "Number of Interactions"
    FROM
      rnacen.rnc_interactions
    GROUP BY
      taxid
    ORDER BY
      "Number of Interactions" DESC
    LIMIT 10;
  EOQ
}

query "databases_by_num_sequences" {
  sql = <<-EOQ
    SELECT
      display_name AS "Database",
      num_sequences AS "Number of Sequences"
    FROM
      rnacen.rnc_database;
  EOQ
}

query "databases_by_num_organisms" {
  sql = <<-EOQ
    SELECT
      display_name AS "Database",
      num_organisms AS "Number of Organisms"
    FROM
      rnacen.rnc_database;
  EOQ
}

# Sample queries based on the available tables
query "total_chemical_components" {
  sql = <<-EOQ
    SELECT COUNT(*) AS "Total Chemical Components"
    FROM rnacen.rnc_chemical_components;
  EOQ
}

query "total_databases" {
  sql = <<-EOQ
    SELECT COUNT(*) AS "Total Databases"
    FROM rnacen.rnc_database;
  EOQ
}

query "total_interactions" {
  sql = <<-EOQ
    SELECT COUNT(*) AS "Total Interactions"
    FROM rnacen.rnc_interactions;
  EOQ
}

query "database_size_comparison" {
  sql = <<-EOQ
    SELECT
      display_name AS "Database",
      num_sequences,
      num_organisms
    FROM
      rnacen.rnc_database;
  EOQ
}

query "coding_probability_vs_fickett_score" {
  sql = <<-EOQ
    SELECT
      coding_probability,
      fickett_score
    FROM
      rnacen.rnc_cpat_results
    WHERE
      coding_probability IS NOT NULL AND
      fickett_score IS NOT NULL;
  EOQ
}

query "modifications_distribution" {
  sql = <<-EOQ
    SELECT
      modification_id,
      COUNT(*) AS "num_modifications"
    FROM
      rnacen.rnc_modifications
    GROUP BY
      modification_id
    ORDER BY
      "num_modifications" DESC
    LIMIT 10;
  EOQ
}

query "chemical_components_distribution" {
  sql = <<-EOQ
    SELECT
      source,
      COUNT(*) AS "Count"
    FROM
      rnacen.rnc_chemical_components
    GROUP BY
      source
    ORDER BY
      "Count" DESC;
  EOQ
}

query "interactions_by_taxid" {
  sql = <<-EOQ
    SELECT
      taxid,
      COUNT(*) AS "Number of Interactions"
    FROM
      rnacen.rnc_interactions
    GROUP BY
      taxid;
  EOQ
}

query "feedback_overlap_analysis" {
  sql = <<-EOQ
    SELECT
      assembly_id,
      COUNT(*) FILTER (WHERE should_ignore = false) AS "Relevant Feedbacks",
      COUNT(*) FILTER (WHERE should_ignore = true) AS "Ignored Feedbacks"
    FROM
      rnacen.rnc_feedback_overlap
    GROUP BY
      assembly_id;
  EOQ
}
