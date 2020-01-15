# == Schema Information
#
# Table name: upload_teis
#
#  id         :bigint           not null, primary key
#  body       :jsonb
#  header     :jsonb
#  references :jsonb
#  upload_id  :integer
#
# Indexes
#
#  index_upload_teis_on_upload_id  (upload_id)
#

class UploadTei < ApplicationRecord
	belongs_to :upload
	has_one :post, through: :upload

	after_create_commit :process

	def process
		# GrobidService.call(id)
		# DiborgService.call(id, post.id)
		GrobidServiceWorker.perform_async(id)
		DiborgServiceWorker.perform_async(id, post.id)
	end

	def doc
		Nokogiri::XML(body)
	end

	def doc_as_hash
		Hash.from_xml(doc.to_xml)
	end

	def bib
		doc.css("biblStruct[@type='array']")
	end

	def bib_as_arr
		doc.css("biblStruct[@type='array']")
			.children
			.css("biblStruct")
			.to_a
			.map{ |w| Hash.from_xml w.to_xml }
	end

	def parse_bib
		bib_arr = []
		doc.css("biblStruct[@type='array']")
			.children
			.css("biblStruct")
			.map { |bibStruct|
				bib_arr << build_citation(bibStruct)
			}
		bib_arr
	end

	def build_citation(bibStruct)
		{
			title: parse_title(bibStruct),
			authors: parse_authors(bibStruct),
			imprint_date: parse_publish_date(bibStruct)
		}

		# need to add post_id and
	end

	def parse_header_title
		title ||= doc.css("teiHeader")
			.css("fileDesc")
			.css("titleStmt")
			.css("title")
			.css("__content__")
			.first
			.content
			.titleize
			.truncate(120)
	end

	def parse_title(bibStruct)
		title = bibStruct.css('title')
			.css('__content__')
			.try(:first)
			.try(:content)
			.try(:titleize)

		title || ""
	end

	def parse_authors(bibStruct)
		authors = bibStruct.css("persName") unless authors.present?
		author_list = []

		authors.map do |author|
			first = author.css("forename __content__")
				.map{|a| a.content}.join(" ")
			last = author.css("surname")
				.inner_html
			full = []
			full << first if first.present?
			full << last if last.present?
			full = full.join(" ")
			author_list << full
		end
		author_list.join(", ")
	end

	def parse_publish_date(bibStruct)
		imprint = bibStruct.css("imprint")
		case imprint.search("type").inner_html
		when "published"
			date = imprint.css('when').inner_html
		end
		date
	end

	def parse_abstract
		doc.css('abstract').to_xml
	end

	def parse_body
		doc.css('body').to_xml
	end
end
